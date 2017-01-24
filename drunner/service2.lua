-- drunner service configuration for minecraft viewer

containername="drunner-${SERVICENAME}-nginx"
datavolume="drunner-${SERVICENAME}-minecraftviewer"

addenv("PORT","8000","The port to run minecraft veiwer on.")
addenv("MINECRAFT","minecraft","The name of the minecraft dService")
addenv("WORLD","world","Name of the minecraft world")

-- everything past here are functions that can be run from the commandline,
-- e.g. helloworld run

function generate()
   result = docker("run","--rm",
   "-e","WORLD",
   "-v","drunner-${MINECRAFT}-minecraftdata:/minecraft/data:ro",
   "-v","drunner-${SERVICENAME}-minecraftviewer:/www:rw",
   "${IMAGENAME}","generate.sh")

   if result~=0 then
      print("Failed to generate minecraft world www files")
   end
end

function purge()
   result = docker("run","--rm",
   "-v","drunner-${SERVICENAME}-minecraftviewer:/www:rw",
   "-u","root",
   "${IMAGENAME}","bash","-c","rm -rf /www/*")

   if result~=0 then
      print("Failed to generate minecraft world www files")
   end
end

function start()
--   generate()
   if (drunning(containername)) then
      print("minecraftviewer is already running.")
   else
      result=docker("run",
      "--name",containername,
      "-p","${PORT}:80",
      "-v","drunner-${SERVICENAME}-minecraftviewer:/usr/share/nginx:ro",
      "-d","nginx")

     if result~=0 then
        print(dsub("Failed to start nginx webserver on port ${PORT}."))
      end
   end

--   autogenerate()
end

function stop()
  dockerstop(containername)
end

function obliterate()
   stop()
end

function uninstall()
   stop()
end

function update()
   stop()
   dockerpull("${IMAGENAME}")
   start()
end

function help()
   return [[
   NAME
      ${SERVICENAME} - Allows you to view minecraft worlds!

   SYNOPSIS
      ${SERVICENAME} help             - This help
      ${SERVICENAME} configure        - Set port and minecraft dService
      ${SERVICENAME} generate         - generate the map
      ${SERVICENAME} purge            - purge map
      ${SERVICENAME} start            - Make it go!
      ${SERVICENAME} stop             - Stop it

   DESCRIPTION
      Built from ${IMAGENAME}.
   ]]
end

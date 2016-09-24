-- drunner service configuration for minecraft viewer

containername="drunner-${SERVICENAME}-nginx"

function drunner_setup()
-- addconfig(NAME, DESCRIPTION, DEFAULT VALUE, TYPE, REQUIRED)
   addconfig("PORT","The port to run minecraft veiwer on.","8000","port",true)
   addconfig("MINECRAFT","The name of the minecraft dService","minecraft","string",true)
   addconfig("WORLD","Name of the minecraft world","world","string",true)
   addconfig("VIRTUAL_HOST","The virtual hostname","","string",false)
   addconfig("GENERATETIME","Minutes between map generation","45","string",false)

-- not user settable
   addconfig("RUNNING","Is the service running","false","bool",true,false)

-- addvolume(NAME, [BACKUP], [EXTERNAL])
   addvolume("drunner-${SERVICENAME}-minecraftviewer",false,false)
-- addcontainer(NAME)

-- addproxy(VIRTUAL_HOST,HTTP_PORT,HTTPS_PORT)
   addproxy("${VIRTUAL_HOST}","${PORT}","")

-- addcron(offsetmin, repeatmin, function)
-- Generate the map every 30 mins
   addcron(17,"${GENERATETIME}","generate")

end


-- everything past here are functions that can be run from the commandline,
-- e.g. helloworld run

function generate()
   result = drun("docker","run","--rm",
   "-e","WORLD",
   "-v","drunner-${MINECRAFT}-minecraftdata:/minecraft/data:ro",
   "-v","drunner-${SERVICENAME}-minecraftviewer:/www:rw",
   "${IMAGENAME}","generate.sh")

   if result~=0 then
      print("Failed to generate minecraft world www files")
   end
end

function purge()
   result = drun("docker","run","--rm",
   "-v","drunner-${SERVICENAME}-minecraftviewer:/www:rw",
   "-u","root",
   "${IMAGENAME}","bash","-c","rm -rf /www/*")

   if result~=0 then
      print("Failed to generate minecraft world www files")
   end
end

function start()
--   generate()
   dconfig_set("RUNNING","true")

   if (drunning(containername)) then
      print("minecraftviewer is already running.")
   else
      result=drun("docker","run",
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
  dconfig_set("RUNNING","false")
  dstop(containername)
end

function obliterate_start()
   stop()
end

function uninstall_start()
   stop()
end

function update_start()
   dstop(containername)
end

function update_end()
   if (dconfig_get("RUNNING")=="true") then
      start()
   end
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

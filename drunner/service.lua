-- drunner service configuration for minecraft viewer

function drunner_setup()
-- addconfig(NAME, DESCRIPTION, DEFAULT VALUE, TYPE, REQUIRED)
   addconfig("PORT","The port to run minecraft veiwer on.","8000","port",true)
   addconfig("MINECRAFT","The name of the minecraft dService","minecraft","string",true)
   addconfig("WORLD","Name of the minecraft world","world","string",true)
-- addvolume(NAME, [BACKUP], [EXTERNAL])
   addvolume("drunner-${SERVICENAME}-minecraftviewer",true,false)
-- addcontainer(NAME)
end


-- everything past here are functions that can be run from the commandline,
-- e.g. helloworld run

function generate()
   result = drun("docker","run","--rm",
   "-v","drunner-${MINECRAFT}-minecraftdata:/minecraft/data",
   "-v","drunner-${SERVICENAME}-minecraftviewer:/www",
   "${IMAGENAME}","/bin/bash","-c",
   "overviewer.py /minecraft/data/${WORLD} /www")

   if result~=0 then
      print("Failed to generate minecraft world www files")
   end
end

function start()
   result=drun("docker","run",
   "--name","nginx-${SERVICENAME}",
   "-p","${PORT}:80",
   "-v","drunner-${SERVICENAME}-minecraftviewer:/usr/share/nginx/html:ro",
   "-d","nginx")

  if result~=0 then
     print(dsub("Failed to start nginx webserver on port ${PORT}."))
   end
end

function stop()
  dstop("nginx-${SERVICENAME}")
end

function obliterate_start()
   stop()
end

function uninstall_start()
   stop()
end

function help()
   return [[
   NAME
      ${SERVICENAME} - Allows you to view minecraft worlds!

   SYNOPSIS
      ${SERVICENAME} help             - This help
      ${SERVICENAME} configure        - Set port and minecraft dService
      ${SERVICENAME} start            - Make it go!
      ${SERVICENAME} stop             - Stop it

   DESCRIPTION
      Built from ${IMAGENAME}.
   ]]
end

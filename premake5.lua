include "code/assimp_code.lua"
include "contrib/assimp_contrib.lua"

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

group "Dependencies"
    include "contrib/zlib"
    include "contrib/zip"
    include "contrib/pugixml"
    include "contrib/openddlparser"
group ""

project "Assimp"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"
    staticruntime "off"
    warnings "off"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")


    files 
    {
        AssimpSourceFiles,
        AssimpImporterSourceFiles,

        ContribSourceFiles
    }

    links
    {
        "zlib",
        "zip",
        "pugixml",
        "openddlparser"
    }
    
    includedirs
    {
        "%{prj.location}/code",
        "%{prj.location}/include",
        "%{prj.location}",
        
        ContribIncludeDirs
    }

    defines
    {
        "RAPIDJSON_HAS_STDSTRING",
        "OPENDDLPARSER_BUILD"
    }

    if (AssimpEnableNoneFreeC4DImporter == false) then
        defines
        {
            "ASSIMP_BUILD_NO_C4D_IMPORTER"
        }
    end
    
    if (AssimpIncludeExporters == false) then
        defines
        {
            "ASSIMP_BUILD_NO_EXPORT"
        }
    end

    -- OS specific
    filter "system:linux"
        pic "On"
		systemversion "latest"

    filter "system:macosx"
		pic "On"

    filter "system:windows"
		systemversion "latest"

    -- Configuration stuff
    filter "configurations:Debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		runtime "Release"
		optimize "Speed"

    filter "configurations:Dist"
		runtime "Release"
		symbols "off"
		optimize "Speed"
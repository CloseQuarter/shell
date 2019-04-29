#!/bin/bash
# Proper header for a Bash script.
#Building an iOS app
#
# 1. Perform Static analysis
# 2. find if workspace of project
# 3. Find target type
# 4. Find deployment version
# 5. find code signing details
# 6. find provisioning profile details    
# 7.. find appropriate scheme to test
# 8. find xcode version
# 9. verbose error log
# 10. dry run
# 11. assets.json
###############
# Helpful links
# https://medium.com/xcblog/xcodebuild-deploy-ios-app-from-command-line-c6defff0d8b8


PRIMARY_BUILD_TOOL='xcodebuild'
# command line parameters
# app name
# app name
APP_NAME='Project'
# expecting a scheme of the same name
SCHEME="${APP_NAME}"

#$ xcodebuild -version
# Xcode 10.2.1
# Build version 10E1001

XCODE_VERSION="$(${PRIMARY_BUILD_TOOL} -version|head -n 1)"
echo ${XCODE_VERSION}

# Look for .xcodeproj or .xcodeworkspace
# error out if not found
# if no path is supplied as $1 then use $CMD
# write anm error routine

# (base) sanoojs-MacBook-Pro:ProSwiftDesignPatterns sanooj$ xcodebuild -list
# Information about project "ProSwiftDesignPatterns":
#     Targets:
#         ProSwiftDesignPatterns
#         ProSwiftDesignPatternsTests
#         ProSwiftDesignPatternsUITests

#     Build Configurations:
#         Debug
#         Release

#     If no build configuration is specified and -scheme is not passed then "Release" is used.

#     Schemes:
#         ProSwiftDesignPatterns
#         ProSwiftDesignPatternsTests
#         ProSwiftDesignPatternsUITests
# xcodebuild -list|sed -n -e '/Targets:/,/Build Configurations:/{ /Targets:/d; /Build Configurations:/d; p; }'
#         ProSwiftDesignPatterns
#         ProSwiftDesignPatternsTests
#         ProSwiftDesignPatternsUITests
######## SCHEMES
# xcodebuild -list|sed -n -e '/Schemes/,/"" C/{ /Schemes/d; /""/ d; p; }'
#         ProSwiftDesignPatterns
#         ProSwiftDesignPatternsTests
#         ProSwiftDesignPatternsUITests

PS3='Please enter your choice: '
options=("Option 1" "Option 2" "Option 3" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        # "Option 1")
        #     echo "you chose choice 1"
        #     ;;
        # "Option 2")
        #     echo "you chose choice 2"
        #     ;;
        # "Option 3")
        #     echo "you chose choice $REPLY which is $opt"
        #     ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
    echo "you chose $opt"
    break
done

CWD="${PWD}"

away_from_home() 
{
  cd "/Volumes/__work/Xcode_projects/ProSwiftDesignPatterns/"
}

homecoming()
{
    cd "${CWD}"
}

#########
###### GET SCHEMES ##########
##########
declare -a SCHEMES
away_from_home
#/usr/bin/xcodebuild/xcodebuild -list
SCHEMES=($(xcodebuild -list|sed -n -e '/Schemes/,/"" C/{ /Schemes/d; /""/ d; p; }'))
# echo "${SCHEMES[@]}"
#echo "${SCHEMES[0]}" 
for scheme in "${SCHEMES[@]}"
do
    echo " oho ${scheme}"
done
homecoming

####
#### TARGETS
#####
away_from_home
echo "${PWD}"
TARGETS=($(xcodebuild -list|sed -n -e '/Targets/,/Build Configurations:/{ /Targets/d; 
 /Build Configurations:/d; s/^[ \t\n\r]*// p; }'))
for scheme in "${TARGETS[@]}"
do
    echo " oho ${scheme}"
done
homecoming


####
#### Build Configurations
#####
away_from_home
echo "${PWD}"
TARGETS=($(xcodebuild -list|sed -n -e '/Build Configurations/,/If no/{ /Build Configurations/d; /If no/d; s/^[ \t\n\r]*// p; }'))
for scheme in "${TARGETS[@]}"
do
    
    # if [ "${scheme}" = "If" ]
    # then
    #     break
    #  fi   

     echo " oho ${scheme}"
done
homecoming
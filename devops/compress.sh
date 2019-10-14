#!/usr/bin/env bash

SELF=$(basename $0)
DIR_NAME=$(dirname $0);
APP_ROOT=$(cd ${DIR_NAME} ; cd .. ; pwd)

while [[ $# -gt 0 ]]
do
    key="$1";
    usage_str="Usage: ./${SELF} --minify [ Minify file before compression ] --help"
    # Read parameters
    case ${key} in
        --minify)
            MINIFY=true
            ;;
        --help)
            echo ${usage_str}
            exit 0
            ;;
        *)  # unknown option
            echo ${usage_str};
            exit 1
            ;;
    esac
    shift
done

function error_handling(){
    msg=$1
    echo "Error:: ${msg}"
    exit 1
}

function minify_and_compress(){
    dir=$1
    file_type=$2

    echo "\nStarted ${file_type} compression for ${WORKSPACE_DIR}"
    find ${WORKSPACE_DIR} -type f -name "*.${file_type}" ! -name "*.min.*" | while read file;
    do

        if [[ ${MINIFY} == true ]]; then
            min_file="${file/.$file_type/.min.$file_type}"
            java -jar ${COMPRESSOR_JAR} --type ${file_type} -o ${min_file} ${file}
            if [[ $? != 0 ]]; then
                error_handling "Minifying failed for file: ${file}"
            fi
            echo "${file} => ${min_file}"
            file=${min_file}
        fi

        gz_file="${file/.$file_type/.$file_type.gz}"
        echo "${file} => ${gz_file}"

        gzip ${file}
        if [[ $? != 0 ]]; then
            error_handling "Compression failed for file: ${file}"
        fi

    done
    echo "Ended ${file_type} compression for ${WORKSPACE_DIR}\n"
}

COMPRESSOR_JAR="${APP_ROOT}/devops/yuicompressor-2.4.8.jar"
if [[ ${MINIFY} == true && -z ${COMPRESSOR_JAR} ]]; then
    error_handling "compressor jar file is missing from location ${COMPRESSOR_JAR}"
fi

# Create workspace dir
APP_DIR="${APP_ROOT}/dev"
WORKSPACE_DIR="${APP_ROOT}/workspace"
rm -rf ${WORKSPACE_DIR}
mkdir ${WORKSPACE_DIR}

# Copy project files to workspace
cp -r ${APP_DIR}/ ${WORKSPACE_DIR}/

# Compress js file
minify_and_compress ${WORKSPACE_DIR} "js"

# Compress css file
minify_and_compress ${WORKSPACE_DIR} "css"

#!/bin/bash

# Check if the argument is a file or a directory
if [ -d "$1" ]; then
    # If a directory is passed, convert all ONNX models in the directory
    echo "Converting ONNX models in directory $1"
    python -m onnxruntime.tools.convert_onnx_models_to_ort $1 --enable_type_reduction

    # Convert the generated ORT files to C headers
    rm -rf ./model/
    mkdir -p ./model
    for ort_file in $1/*.ort; do
        python -m bin2c -o ./model/$(basename $ort_file .ort).ort $ort_file
    done
elif [ -f "$1" ]; then
    # If a file is passed, convert the single ONNX model
    echo "Converting ONNX model file $1"
    python -m onnxruntime.tools.convert_onnx_models_to_ort $1 --enable_type_reduction

    # Convert the generated ORT file to a C header
    rm -rf ./model/
    mkdir -p ./model
    python -m bin2c -o ./model/model.ort $(dirname $1)/$(basename $1 .onnx).ort
else
    echo "Invalid input: $1 is neither a file nor a directory"
    exit 1
fi

# Uncomment to verify the model (if you have a verify_model.py script)
# python verify_model.py


#!/bin/bash

#python -m tf2onnx.convert --saved-model model --output model.onnx --opset 13
#python -m onnxruntime.tools.convert_onnx_models_to_ort $1 --enable_type_reduction
#rm -R ./model/
#mkdir -p ./model
## python verify_model.py
#python -m bin2c -o ./model/model.ort model.ort

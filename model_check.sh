#!/bin/bash
probcli_path=/usr/software/ProB/probcli
model_check="-model-check -mc-mode bf -p COMPRESSION TRUE -p DOT_IDS TRUE -memory -disable-timeout --coverage-summary"
m2dot="-dot state_space_sfdp"
dot_path=/usr/bin/dot
dot2pdf="-Ksfdp -x -Goverlap=scale -Tpdf"

echo "Generate state spaces? (y or n)"
read space
echo "Please select the model to check:"
echo "input \"n\" for Nested Kernel, \"h\" for Hilps, or \"all\""
read model
if [ $space = "y" ] || [ $space = "Y" ];then
    case $model in
        "n")
            echo "Start Nested Kernel model checking..."
            $probcli_path ./Nested_Kernel/Priv_Domain_NK.mch $model_check $m2dot ./Nested_Kernel/Nested_Kernel.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf ./Nested_Kernel/Nested_Kernel.dot -o ./Nested_Kernel/Nested_Kernel.pdf
            ;;
        "h")
            echo "Start Hilps model checking..."
            $probcli_path ./Hilps/Priv_Domain_Hilps.mch $model_check $m2dot ./Hilps/Hilps.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf ./Hilps/Hilps.dot -o ./Hilps/Hilps.pdf
            ;;
        "all")
            echo "Start Nested Kernel model checking..."
            echo "Nested Kernel" > model_check.txt
            $probcli_path ./Nested_Kernel/Priv_Domain_NK.mch $model_check $m2dot ./Nested_Kernel/Nested_Kernel.dot >> model_check.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf ./Nested_Kernel/Nested_Kernel.dot -o ./Nested_Kernel/Nested_Kernel.pdf
            echo "Start Hilps model checking..."
            echo "Hilps" >> model_check.txt
            $probcli_path ./Hilps/Priv_Domain_Hilps.mch $model_check $m2dot ./Hilps/Hilps.dot >> model_check.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf ./Hilps/Hilps.dot -o ./Hilps/Hilps.pdf
            ;;
        *)
            echo "Wrong parameters!"
            ;;
    esac
else
    case $model in
        "n")
            echo "Start Nested Kernel model checking..."
            $probcli_path ./Nested_Kernel/Priv_Domain_NK.mch $model_check
            ;;
        "h")
            echo "Start Hilps model checking..."
            $probcli_path ./Hilps/Priv_Domain_Hilps.mch $model_check
            ;;
        "all")
            echo "Start Nested Kernel model checking..."
            echo "Nested Kernel" > model_check.txt
            $probcli_path ./Nested_Kernel/Priv_Domain_NK.mch $model_check >> model_check.txt
            echo "Start Hilps model checking..."
            echo "Hilps" >> model_check.txt
            $probcli_path ./Hilps/Priv_Domain_Hilps.mch $model_check >> model_check.txt
            ;;
        *)
            echo "Wrong parameters!"
            ;;
    esac
fi

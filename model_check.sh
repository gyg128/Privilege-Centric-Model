#!/bin/bash
probcli_path=/usr/software/ProB/probcli
model_check="-model-check -mc-mode bf -p COMPRESSION TRUE -p DOT_IDS TRUE -memory -disable-timeout --coverage-summary"
m2dot="-dot state_space_sfdp"
dot_path=/usr/bin/dot
dot2pdf="-Ksfdp -x -Goverlap=scale -Tpdf"

echo "Generate state spaces? (y or n)"
read space
echo "Please select the model to check:"
echo "input \"n\" for Nested Kernel, \"h\" for Hilps, \"sk7\" for SKEE_ARMv7, \"sk8\" for SKEE_ARMv8, \"sm\" for SelMon, or \"all\""
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
        "sk7")
            echo "Start SKEE_ARMv7 model checking..."
            $probcli_path ./SKEE/Priv_Domain_SKEEv7.mch $model_check $m2dot ./SKEE/SKEEv7.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf ./SKEE/SKEEv7.dot -o ./SKEE/SKEEv7.pdf
            ;;
        "sk8")
            echo "Start SKEE_ARMv8 model checking..."
            $probcli_path ./SKEE/Priv_Domain_SKEEv8.mch $model_check $m2dot ./SKEE/SKEEv8.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf ./SKEE/SKEEv8.dot -o ./SKEE/SKEEv8.pdf
            ;;
        "sm")
            echo "Start SelMon model checking..."
            $probcli_path ./SelMon/Priv_Domain_SelMon.mch $model_check $m2dot ./SelMon/SelMon.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf ./SelMon/SelMon.dot -o ./SelMon/SelMon.pdf
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
            echo "Start SKEE_ARMv7 model checking..."
            echo "SKEE_ARMv7" >> model_check.txt
            $probcli_path ./SKEE/Priv_Domain_SKEEv7.mch $model_check $m2dot ./SKEE/SKEEv7.dot >> model_check.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf ./SKEE/SKEEv7.dot -o ./SKEE/SKEEv7.pdf
            echo "Start SKEE_ARMv8 model checking..."
            echo "SKEE_ARMv8" >> model_check.txt
            $probcli_path ./SKEE/Priv_Domain_SKEEv8.mch $model_check $m2dot ./SKEE/SKEEv8.dot >> model_check.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf ./SKEE/SKEEv8.dot -o ./SKEE/SKEEv8.pdf
            echo "Start SelMon model checking..."
            echo "SelMon" >> model_check.txt
            $probcli_path ./SelMon/Priv_Domain_SelMon.mch $model_check $m2dot ./SelMon/SelMon.dot >> model_check.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf ./SelMon/SelMon.dot -o ./SelMon/SelMon.pdf
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
        "sk7")
            echo "Start SKEE_ARMv7 model checking..."
            $probcli_path ./SKEE/Priv_Domain_SKEEv7.mch $model_check
            ;;
        "sk8")
            echo "Start SKEE_ARMv8 model checking..."
            $probcli_path ./SKEE/Priv_Domain_SKEEv8.mch $model_check
            ;;
        "sm")
            echo "Start SelMon model checking..."
            $probcli_path ./SelMon/Priv_Domain_SelMon.mch $model_check
            ;;
        "all")
            echo "Start Nested Kernel model checking..."
            echo "Nested Kernel" > model_check.txt
            $probcli_path ./Nested_Kernel/Priv_Domain_NK.mch $model_check >> model_check.txt
            echo "Start Hilps model checking..."
            echo "Hilps" >> model_check.txt
            $probcli_path ./Hilps/Priv_Domain_Hilps.mch $model_check >> model_check.txt
            echo "Start SKEE_ARMv7 model checking..."
            echo "SKEE_ARMv7" >> model_check.txt
            $probcli_path ./SKEE/Priv_Domain_SKEEv7.mch $model_check >> model_check.txt
            echo "Start SKEE_ARMv8 model checking..."
            echo "SKEE_ARMv8" >> model_check.txt
            $probcli_path ./SKEE/Priv_Domain_SKEEv8.mch $model_check >> model_check.txt
            echo "Start SelMon model checking..."
            echo "SelMon" >> model_check.txt
            $probcli_path ./SelMon/Priv_Domain_SelMon.mch $model_check >> model_check.txt
            ;;
        *)
            echo "Wrong parameters!"
            ;;
    esac
fi

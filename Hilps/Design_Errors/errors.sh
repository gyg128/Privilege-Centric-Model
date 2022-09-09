#!/bin/bash
#probcli_path=/usr/software/ProB/probcli
probcli_path=~/Documents/App/ProB/probcli
model_check="-model-check -mc-mode bf -p COMPRESSION TRUE -p DOT_IDS TRUE -memory -disable-timeout --coverage-summary"
m2dot="-dot state_space_sfdp"
dot_path=/usr/bin/dot
dot2pdf="-Ksfdp -x -Goverlap=scale -Tpdf"

echo "Generate state spaces? (y or n)"
read space
echo "Please select the design error number: 1-7/all"
read model
if [ $space = "y" ] || [ $space = "Y" ];then
    case $model in
        "1")
            echo "Start Error1_pt model checking..."
            $probcli_path Error1_pt_Domain.mch $model_check $m2dot Error1_pt_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Error1_pt_Domain.dot -o Error1_pt_Domain.pdf
            ;;
        "2")
            echo "Start Error2_iopt model checking..."
            $probcli_path Error2_iopt_Domain.mch $model_check $m2dot Error2_iopt_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Error2_iopt_Domain.dot -o Error2_iopt_Domain.pdf
            ;;
        "3")
            echo "Start Error3_idt model checking..."
            $probcli_path Error3_idt_Domain.mch $model_check $m2dot Error3_idt_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Error3_idt_Domain.dot -o Error3_idt_Domain.pdf
            ;;
        "4")
            echo "Start Error4_stack model checking..."
            $probcli_path Error4_stack_Domain.mch $model_check $m2dot Error4_stack_Domain.dot
            #echo "Generating the state space..."
            #$dot_path $dot2pdf Error4_stack_Domain.dot -o Error4_stack_Domain.pdf
            ;;
        "5")
            echo "Start Error5_tcr model checking..."
            $probcli_path Error5_tcr_Domain.mch $model_check $m2dot Error5_tcr_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Error5_tcr_Domain.dot -o Error5_tcr_Domain.pdf
            ;;
        "6")
            echo "Start Error6_ttbr model checking..."
            $probcli_path Error6_ttbr_Domain.mch $model_check $m2dot Error6_ttbr_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Error6_ttbr_Domain.dot -o Error6_ttbr_Domain.pdf
            ;;
        "7")
            echo "Start Error7_vbar model checking..."
            $probcli_path Error7_vbar_Domain.mch $model_check $m2dot Error7_vbar_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Error7_vbar_Domain.dot -o Error7_vbar_Domain.pdf
            ;;
        "all")
            echo "Start Error1_pt model checking..."
            echo "Error1_pt" > errors.txt
            $probcli_path Error1_pt_Domain.mch $model_check $m2dot Error1_pt_Domain.dot >> errors.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Error1_pt_Domain.dot -o Error1_pt_Domain.pdf
            echo "Start Error2_iopt model checking..."
            echo "Error2_iopt" >> errors.txt
            $probcli_path Error2_iopt_Domain.mch $model_check $m2dot Error2_iopt_Domain.dot >> errors.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Error2_iopt_Domain.dot -o Error2_iopt_Domain.pdf
            echo "Start Error3_idt model checking..."
            echo "Error3_idt" >> errors.txt
            $probcli_path Error3_idt_Domain.mch $model_check $m2dot Error3_idt_Domain.dot >> errors.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Error3_idt_Domain.dot -o Error3_idt_Domain.pdf
            echo "Start Error4_stack model checking..."
            echo "Error4_stack" >> errors.txt
            $probcli_path Error4_stack_Domain.mch $model_check $m2dot Error4_stack_Domain.dot >> errors.txt
            #echo "Generating the state space..."
            #$dot_path $dot2pdf Error4_stack_Domain.dot -o Error4_stack_Domain.pdf
            echo "Start Error5_tcr model checking..."
            echo "Error5_tcr" >> errors.txt
            $probcli_path Error5_tcr_Domain.mch $model_check $m2dot Error5_tcr_Domain.dot >> errors.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Error5_tcr_Domain.dot -o Error5_tcr_Domain.pdf
            echo "Start Error6_ttbr model checking..."
            echo "Error6_ttbr" >> errors.txt
            $probcli_path Error6_ttbr_Domain.mch $model_check $m2dot Error6_ttbr_Domain.dot >> errors.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Error6_ttbr_Domain.dot -o Error6_ttbr_Domain.pdf
            echo "Start Error7_vbar model checking..."
            echo "Error7_vbar" >> errors.txt
            $probcli_path Error7_vbar_Domain.mch $model_check $m2dot Error7_vbar_Domain.dot >> errors.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Error7_vbar_Domain.dot -o Error7_vbar_Domain.pdf
            ;;
        *)
            echo "Wrong parameters!"
            ;;
    esac
else
    case $model in
        "1")
            echo "Start Error1_pt model checking..."
            $probcli_path Error1_pt_Domain.mch $model_check
            ;;
        "2")
            echo "Start Error2_iopt model checking..."
            $probcli_path Error2_iopt_Domain.mch $model_check
            ;;
        "3")
            echo "Start Error3_idt model checking..."
            $probcli_path Error3_idt_Domain.mch $model_check
            ;;
        "4")
            echo "Start Error4_stack model checking..."
            $probcli_path Error4_stack_Domain.mch $model_check
            ;;
        "5")
            echo "Start Error5_tcr model checking..."
            $probcli_path Error5_tcr_Domain.mch $model_check
            ;;
        "6")
            echo "Start Error6_ttbr model checking..."
            $probcli_path Error6_ttbr_Domain.mch $model_check
            ;;
        "7")
            echo "Start Error7_vbar model checking..."
            $probcli_path Error7_vbar_Domain.mch $model_check
            ;;
        "all")
            echo "Start Error1_pt model checking..."
            echo "Error1_pt" > errors.txt
            $probcli_path Error1_pt_Domain.mch $model_check >> errors.txt
            echo "Start Error2_iopt model checking..."
            echo "Error2_iopt" >> errors.txt
            $probcli_path Error2_iopt_Domain.mch $model_check >> errors.txt
            echo "Start Error3_idt model checking..."
            echo "Error3_idt" >> errors.txt
            $probcli_path Error3_idt_Domain.mch $model_check >> errors.txt
            echo "Start Error4_stack model checking..."
            echo "Error4_stack" >> errors.txt
            $probcli_path Error4_stack_Domain.mch $model_check >> errors.txt
            echo "Start Error5_tcr model checking..."
            echo "Error5_tcr" >> errors.txt
            $probcli_path Error5_tcr_Domain.mch $model_check >> errors.txt
            echo "Start Error6_ttbr model checking..."
            echo "Error6_ttbr" >> errors.txt
            $probcli_path Error6_ttbr_Domain.mch $model_check >> errors.txt
            echo "Start Error7_vbar model checking..."
            echo "Error7_vbar" >> errors.txt
            $probcli_path Error7_vbar_Domain.mch $model_check >> errors.txt
            ;;
        *)
            echo "Wrong parameters!"
            ;;
    esac
fi

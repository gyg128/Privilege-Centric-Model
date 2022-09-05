#!/bin/bash
probcli_path=/usr/software/ProB/probcli
model_check="-model-check -mc-mode bf -p COMPRESSION TRUE -p DOT_IDS TRUE -memory -disable-timeout --coverage-summary"
m2dot="-dot state_space_sfdp"
dot_path=/usr/bin/dot
dot2pdf="-Ksfdp -x -Goverlap=scale -Tpdf"

echo "Generate state spaces? (y or n)"
read space
echo "Please select the attack scenario number: 1-10/all"
read model
if [ $space = "y" ] || [ $space = "Y" ];then
    case $model in
        "1")
            echo "Start Attack1_pt model checking..."
            $probcli_path Attack1_pt_Domain.mch $model_check $m2dot Attack1_pt_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack1_pt_Domain.dot -o Attack1_pt_Domain.pdf
            ;;
        "2")
            echo "Start Attack2_io model checking..."
            $probcli_path Attack2_io_Domain.mch $model_check $m2dot Attack2_io_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack2_io_Domain.dot -o Attack2_io_Domain.pdf
            ;;
        "3")
            echo "Start Attack3_idt model checking..."
            $probcli_path Attack3_idt_Domain.mch $model_check $m2dot Attack3_idt_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack3_idt_Domain.dot -o Attack3_idt_Domain.pdf
            ;;
        "4")
            echo "Start Attack4_stack model checking..."
            $probcli_path Attack4_stack_Domain.mch $model_check $m2dot Attack4_stack_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack4_stack_Domain.dot -o Attack4_stack_Domain.pdf
            ;;
        "5")
            echo "Start Attack5_gate model checking..."
            $probcli_path Attack5_gate_Domain.mch $model_check $m2dot Attack5_gate_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack5_gate_Domain.dot -o Attack5_gate_Domain.pdf
            ;;
        "6")
            echo "Start Attack6_gate model checking..."
            $probcli_path Attack6_gate_Domain.mch $model_check $m2dot Attack6_gate_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack6_gate_Domain.dot -o Attack6_gate_Domain.pdf
            ;;
        "7")
            echo "Start Attack7_gate model checking..."
            $probcli_path Attack7_gate_Domain.mch $model_check $m2dot Attack7_gate_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack7_gate_Domain.dot -o Attack7_gate_Domain.pdf
            ;;
        "8")
            echo "Start Attack8_cr0 model checking..."
            $probcli_path Attack8_cr0_Domain.mch $model_check $m2dot Attack8_cr0_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack8_cr0_Domain.dot -o Attack8_cr0_Domain.pdf
            ;;
        "9")
            echo "Start Attack9_cr3 model checking..."
            $probcli_path Attack9_cr3_Domain.mch $model_check $m2dot Attack9_cr3_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack9_cr3_Domain.dot -o Attack9_cr3_Domain.pdf
            ;;
        "10")
            echo "Start Attack10_idtr model checking..."
            $probcli_path Attack10_idtr_Domain.mch $model_check $m2dot Attack10_idtr_Domain.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack10_idtr_Domain.dot -o Attack10_idtr_Domain.pdf
            ;;
        "all")
            echo "Start Attack1_pt model checking..."
            echo "Attack1_pt" > attacks.txt
            $probcli_path Attack1_pt_Domain.mch $model_check $m2dot Attack1_pt_Domain.dot >> attacks.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack1_pt_Domain.dot -o Attack1_pt_Domain.pdf
            echo "Start Attack2_io model checking..."
            echo "Attack2_io" >> attacks.txt
            $probcli_path Attack2_io_Domain.mch $model_check $m2dot Attack2_io_Domain.dot >> attacks.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack2_io_Domain.dot -o Attack2_io_Domain.pdf
            echo "Start Attack3_idt model checking..."
            echo "Attack3_idt" >> attacks.txt
            $probcli_path Attack3_idt_Domain.mch $model_check $m2dot Attack3_idt_Domain.dot >> attacks.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack3_idt_Domain.dot -o Attack3_idt_Domain.pdf
            echo "Start Attack4_stack model checking..."
            echo "Attack4_stack" >> attacks.txt
            $probcli_path Attack4_stack_Domain.mch $model_check $m2dot Attack4_stack_Domain.dot >> attacks.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack4_stack_Domain.dot -o Attack4_stack_Domain.pdf
            echo "Start Attack5_gate model checking..."
            echo "Attack5_gate" >> attacks.txt
            $probcli_path Attack5_gate_Domain.mch $model_check $m2dot Attack5_gate_Domain.dot >> attacks.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack5_gate_Domain.dot -o Attack5_gate_Domain.pdf
            echo "Start Attack6_gate model checking..."
            echo "Attack6_gate" >> attacks.txt
            $probcli_path Attack6_gate_Domain.mch $model_check $m2dot Attack6_gate_Domain.dot >> attacks.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack6_gate_Domain.dot -o Attack6_gate_Domain.pdf
            echo "Start Attack7_gate model checking..."
            echo "Attack7_gate" >> attacks.txt
            $probcli_path Attack7_gate_Domain.mch $model_check $m2dot Attack7_gate_Domain.dot >> attacks.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack7_gate_Domain.dot -o Attack7_gate_Domain.pdf
            echo "Start Attack8_cr0 model checking..."
            echo "Attack8_cr0" >> attacks.txt
            $probcli_path Attack8_cr0_Domain.mch $model_check $m2dot Attack8_cr0_Domain.dot >> attacks.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack8_cr0_Domain.dot -o Attack8_cr0_Domain.pdf
            echo "Start Attack9_cr3 model checking..."
            echo "Attack9_cr3" >> attacks.txt
            $probcli_path Attack9_cr3_Domain.mch $model_check $m2dot Attack9_cr3_Domain.dot >> attacks.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack9_cr3_Domain.dot -o Attack9_cr3_Domain.pdf
            echo "Start Attack10_idtr model checking..."
            echo "Attack10_idtr" >> attacks.txt
            $probcli_path Attack10_idtr_Domain.mch $model_check $m2dot Attack10_idtr_Domain.dot >> attacks.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Attack10_idtr_Domain.dot -o Attack10_idtr_Domain.pdf
            ;;
        *)
            echo "Wrong parameters!"
            ;;
    esac
else
    case $model in
        "1")
            echo "Start Attack1_pt model checking..."
            $probcli_path Attack1_pt_Domain.mch $model_check
            ;;
        "2")
            echo "Start Attack2_io model checking..."
            $probcli_path Attack2_io_Domain.mch $model_check
            ;;
        "3")
            echo "Start Attack3_idt model checking..."
            $probcli_path Attack3_idt_Domain.mch $model_check
            ;;
        "4")
            echo "Start Attack4_stack model checking..."
            $probcli_path Attack4_stack_Domain.mch $model_check
            ;;
        "5")
            echo "Start Attack5_gate model checking..."
            $probcli_path Attack5_gate_Domain.mch $model_check
            ;;
        "6")
            echo "Start Attack6_gate model checking..."
            $probcli_path Attack6_gate_Domain.mch $model_check
            ;;
        "7")
            echo "Start Attack7_gate model checking..."
            $probcli_path Attack7_gate_Domain.mch $model_check
            ;;
        "8")
            echo "Start Attack8_cr0 model checking..."
            $probcli_path Attack8_cr0_Domain.mch $model_check
            ;;
        "9")
            echo "Start Attack9_cr3 model checking..."
            $probcli_path Attack9_cr3_Domain.mch $model_check
            ;;
        "10")
            echo "Start Attack10_idtr model checking..."
            $probcli_path Attack10_idtr_Domain.mch $model_check
            ;;
        "all")
            echo "Start Attack1_pt model checking..."
            echo "Attack1_pt" > attacks.txt
            $probcli_path Attack1_pt_Domain.mch $model_check >> attacks.txt
            echo "Start Attack2_io model checking..."
            echo "Attack2_io" >> attacks.txt
            $probcli_path Attack2_io_Domain.mch $model_check >> attacks.txt
            echo "Start Attack3_idt model checking..."
            echo "Attack3_idt" >> attacks.txt
            $probcli_path Attack3_idt_Domain.mch $model_check >> attacks.txt
            echo "Start Attack4_stack model checking..."
            echo "Attack4_stack" >> attacks.txt
            $probcli_path Attack4_stack_Domain.mch $model_check >> attacks.txt
            echo "Start Attack5_gate model checking..."
            echo "Attack5_gate" >> attacks.txt
            $probcli_path Attack5_gate_Domain.mch $model_check >> attacks.txt
            echo "Start Attack6_gate model checking..."
            echo "Attack6_gate" >> attacks.txt
            $probcli_path Attack6_gate_Domain.mch $model_check >> attacks.txt
            echo "Start Attack7_gate model checking..."
            echo "Attack7_gate" >> attacks.txt
            $probcli_path Attack7_gate_Domain.mch $model_check >> attacks.txt
            echo "Start Attack8_cr0 model checking..."
            echo "Attack8_cr0" >> attacks.txt
            $probcli_path Attack8_cr0_Domain.mch $model_check >> attacks.txt
            echo "Start Attack9_cr3 model checking..."
            echo "Attack9_cr3" >> attacks.txt
            $probcli_path Attack9_cr3_Domain.mch $model_check >> attacks.txt
            echo "Start Attack10_idtr model checking..."
            echo "Attack10_idtr" >> attacks.txt
            $probcli_path Attack10_idtr_Domain.mch $model_check >> attacks.txt
            ;;
        *)
            echo "Wrong parameters!"
            ;;
    esac
fi

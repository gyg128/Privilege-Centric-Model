#!/bin/bash
probcli_path=/usr/software/ProB/probcli
model_check="-model-check -mc-mode bf -p COMPRESSION TRUE -p DOT_IDS TRUE -memory -disable-timeout --coverage-summary"
m2dot="-dot state_space_sfdp"
dot_path=/usr/bin/dot
dot2pdf="-Ksfdp -x -Goverlap=scale -Tpdf"

echo "Generate state spaces? (y or n)"
read space
echo "Please select the contract to be lacking: 1/2/3/all"
read model
if [ $space = "y" ] || [ $space = "Y" ];then
    case $model in
        "1")
            echo "Start model checking in the lack of C1..."
            $probcli_path Lack_C1.mch $model_check $m2dot Lack_C1.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Lack_C1.dot -o Lack_C1.pdf
            ;;
        "2")
            echo "Start model checking in the lack of C2..."
            $probcli_path Lack_C2.mch $model_check $m2dot Lack_C2.dot
            #echo "Generating the state space..."
            #$dot_path $dot2pdf Lack_C2.dot -o Lack_C2.pdf
            ;;
        "3")
            echo "Start model checking in the lack of C3..."
            $probcli_path Lack_C3.mch $model_check $m2dot Lack_C3.dot
            echo "Generating the state space..."
            $dot_path $dot2pdf Lack_C3.dot -o Lack_C3.pdf
            ;;
        "all")
            echo "Start model checking in the lack of C1..."
            echo "Lack of C1" > contracts.txt
            $probcli_path Lack_C1.mch $model_check $m2dot Lack_C1.dot >> contracts.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Lack_C1.dot -o Lack_C1.pdf
            echo "Start model checking in the lack of C2..."
            echo "Lack of C2" >> contracts.txt
            $probcli_path Lack_C2.mch $model_check $m2dot Lack_C2.dot >> contracts.txt
            #echo "Generating the state space..."
            #$dot_path $dot2pdf Lack_C2.dot -o Lack_C2.pdf
            echo "Start model checking in the lack of C3..."
            echo "Lack of C3" >> contracts.txt
            $probcli_path Lack_C3.mch $model_check $m2dot Lack_C3.dot >> contracts.txt
            echo "Generating the state space..."
            $dot_path $dot2pdf Lack_C3.dot -o Lack_C3.pdf
            ;;
        *)
            echo "Wrong parameters!"
            ;;
    esac
else
    case $model in
        "1")
            echo "Start model checking in the lack of C1..."
            $probcli_path Lack_C1.mch $model_check
            ;;
        "2")
            echo "Start model checking in the lack of C2..."
            $probcli_path Lack_C2.mch $model_check
            ;;
        "3")
            echo "Start model checking in the lack of C3..."
            $probcli_path Lack_C3.mch $model_check
            ;;
        "all")
            echo "Start model checking in the lack of C1..."
            echo "Lack of C1" > contracts.txt
            $probcli_path Lack_C1.mch $model_check >> contracts.txt
            echo "Start model checking in the lack of C2..."
            echo "Lack of C2" >> contracts.txt
            $probcli_path Lack_C2.mch $model_check >> contracts.txt
            echo "Start model checking in the lack of C3..."
            echo "Lack of C3" >> contracts.txt
            $probcli_path Lack_C3.mch $model_check >> contracts.txt
            ;;
        *)
            echo "Wrong parameters!"
            ;;
    esac
fi

# Artifact Evaluation - ACSAC'22

Thank you for your time and picking our paper for the artifact evaluation.

This documentation contains steps necessary to reproduce the artifact for our paper titled **Formal Modeling and Security Analysis for Intra-level Privilege Separation**.

## Abstract

We propose a general and extensible formal framework for intra-level privilege separation. The artifact contains the B source code of Nested Kernel and Hilps models as well as the corresponding abstract machines for security analysis. We rely on ProB-1.11.1 to perform model checking, which requires Java 7 or newer and Graphviz. All state space visualization results, including Figures 6-7 in the paper, and scripts to reproduce the evaluation are also released in the repository. The instantiated privilege-centric models are described in Section 5 and evaluated in Section 6 to obtain Table 1. The security analysis consists of security contract analysis, design error detection, and attack scenario simulation in Section 7, resulting in Tables 2-7. Most model checking experiments will be completed in a few seconds. Only the largest model (C2 in Table 5) took about 53 minutes on a machine with an Intel i7-10700 CPU and 16GB RAM.

## Setting up the environment

* Use the [docker image](https://hub.docker.com/r/gangna/ubuntu/tags).

```
docker pull gangna/ubuntu:pcm
docker run -it gangna/ubuntu:pcm /bin/bash
cd /usr/software/pcm
```

### Manual setup

* Download and install [ProB-1.11.1](https://prob.hhu.de/w/index.php?title=Download), which requires Java 7 or newer and [Graphviz](https://www.graphviz.org/download/). Tcl/Tk is not necessary for probcli (the command line version of ProB).

* Confirm `probcli_path` and `dot_path` in the scripts.

## Script explanation

```
$probcli_path *.mch -model-check -mc-mode bf -p COMPRESSION TRUE -p DOT_IDS TRUE -memory -disable-timeout --coverage-summary -dot state_space_sfdp *.dot
```
* `-mc-mode bf`: Breadth-first traversal.

* `-p COMPRESSION TRUE`: Reduce the memory consumption.

* `-p DOT_IDS TRUE`: Show node identifiers in the dot file.

* `-memory`: Print the memory consumption.

* `-disable-timeout`: Time-out checking incurs some overhead, and is probably most useful in animation mode and not in exhaustive model checking mode.

* `--coverage-summary`: Print the summary of coverage statistics.

* `-dot state_space_sfdp *.dot`: Show state space (fast).

```
$dot_path -Ksfdp -x -Goverlap=scale -Tpdf *.dot -o *.pdf
```
* Generate the state space pdf from the dot file using the fast display algorithm.

## Model checking

### Table 1

* Execute `./model_check.sh`

* Follow the prompts for input,
```
Generate state spaces? (y or n)
Please select the model to check:
input "n" for Nested Kernel, "h" for Hilps, or "all"
```
Selecting "all" will output the results to model_check.txt.

#### Examples

![example1](https://github.com/gyg128/Privilege-Centric-Model/blob/main/Examples/example1.png)

* "States analysed" do not include the virtual root node and are therefore less than the coverage statistics.

* "model_check_incomplete" is due to the fact that we only need to choose one of all equivalent initialization options.

* The uncovered operations mean that a secure model will not execute them maliciously after initialization.

## Security analysis

### Table 2 (Lack of contracts)

* `cd Nested_Kernel/Lack_of_Contract/`

* Execute `./contracts.sh`

* Follow the prompts for input,
```
Generate state spaces? (y or n)
Please select the contract to be lacking: 1/2/3/all
```
Selecting "all" will output the results to contracts.txt.

#### Examples

![example2](https://github.com/gyg128/Privilege-Centric-Model/blob/main/Examples/example2.png)

* Due to page limit, we only list key operations in the table, such as omitting "SETUP_CONSTANTS".

* Since there are type invariants in front, "Invariant 13-17" in the output corresponds to "I1-I5" in the paper.

* The uncovered operations are due to the invariant violation.

* The state space of C2 is too large, so we did not generate a pdf for it.

### Table 3 (Design errors)

* `cd Nested_Kernel/Design_Errors/`

* Execute `./errors.sh`

* Follow the prompts for input,
```
Generate state spaces? (y or n)
Please select the design error number: 1-8/all
```
Selecting "all" will output the results to errors.txt.

#### Notes

* The type error of no.1 will lead to an abort error.

* "P2N_switch()" in the table represents a series of sequentially executed sub-operations (cf. last on page 5).

### Table 4 (Attack scenarios)

* `cd Nested_Kernel/Attack_Scenarios/`

* Execute `./attacks.sh`

* Follow the prompts for input,
```
Generate state spaces? (y or n)
Please select the attack scenario number: 1-10/all
```
Selecting "all" will output the results to attacks.txt.

#### Notes

* Attacks 5-7 will break the atomicity of "P2N_switch()".

* Any type errors resulting from I1-I5 violations are omitted from the table.

### Tables 5-7 in the appendices (Security analysis results of Hilps)

* Similar to Tables 2-4, execute the corresponding scripts in `Hilps/`.

#### Notes

* "Invariant 14-19" in the output of Hilps corresponds to "I1-I6" in the paper.

* We did not generate the pdf files for the large state spaces of C2 in Table 5 and Error4 in Table 6.

* Refer to Section 7.4 for the security comparison of Nested Kernel and Hilps.

## Approximate execution time

The model checking time on a machine with an Intel i7-10700 CPU and 16GB RAM is shown in Tables 1-7. Most experiments will be completed in a few seconds, with the largest model (C2 in Table 5) taking about 53 minutes.

Generating the state space pdf files will take a few more seconds, except for Hilps in Table 1, which takes about 5 minutes.
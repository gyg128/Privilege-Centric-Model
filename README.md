# Artifact Evaluation - ACSAC'22

Thank you for your time and picking our paper for the artifact evaluation.

## Abstract

We propose a general and extensible formal framework for intra-level privilege separation. The artifact contains the B source code of Nested Kernel and Hilps models as well as the corresponding abstract machines for security analysis. We rely on ProB-1.11.1 to perform model checking, which requires Java 7 or newer and Graphviz. All state space visualization results, including Figures 6-7 in the paper, and scripts to reproduce the evaluation are also released in the repository. The instantiated privilege-centric models are described in Section 5 and evaluated in Section 6 to obtain Table 1. The security analysis consists of security contract analysis, design error detection, and attack scenario simulation in Section 7, resulting in Tables 2-4, respectively. Most model checking experiments will be completed in a few seconds, except for C2 in Table 2, which took about 3 minutes on a machine with an Intel i7-10700 CPU and 16GB RAM.
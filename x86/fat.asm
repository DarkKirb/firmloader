struc bpb
    .skip resb 3
    .oem resb 8
    .bytesPSector resw 1
    .sectorsPCluster resb 1
    .resSectors resw 1
    .noFAT resb 1
    .noDirent resw 1
    .noTotSecS resw 1
    .mdt resb 1
    .secPFAT resw 1
    .secPTrack resw 1
    .noHeads resw 1
    .hiddenSecs resd 1
    .noTotSecL resd 1
    .driveNum resb 1
    .flagsNT resb 1
    .signature resb 1
    .volumeID resd 1
    .volumeLabel resb 11
    .sysident resb 8
    .bootcode resb 448
    .partsig resw 1
endstruc
struc dirent
    .fname resb 11
    .attrib resb 1
    .winnt resb 1
    .creationtimtenth resb 1
    .creationtim resw 1
    .creationdat resw 1
    .accessdat resw 1
    .hicluster resw 1
    .lastmod resw 2
    .cluster resw 1
    .filesize resd 1
endstruc

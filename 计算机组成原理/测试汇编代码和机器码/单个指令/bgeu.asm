lui x1,1
lui x2,0x80000
sltu x3,x1,x2
sltiu x4,x1,-1
bgeu x2,x1,end
lui x1,3
end:
lui x1,2
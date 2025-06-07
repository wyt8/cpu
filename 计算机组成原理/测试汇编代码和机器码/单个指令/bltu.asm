lui x1,1
lui x2,0x80000
sltu x3,x1,x2
sltiu x4,x1,-1
bltu x1,x2,end1
end1:
lui x1,2
lui x1,3

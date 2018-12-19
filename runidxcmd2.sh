mkdir idx
python /Users/cam/code/ir/trunk/bin/Scripts/createidx.py --visus /Users/cam/code/ir/trunk/bin/visus/osx/visusconvert --dims "8517 9240 16" --name "idx/0001-ntdata.idx" --fields "DAPI BEN VAS OXY" --dtype uint8
python /Users/cam/code/ir/trunk/bin/Scripts/createidx.py --visus /Users/cam/code/ir/trunk/bin/visus/osx/visusconvert --dims "8517 9240 13" --name "idx/0002-ntdata.idx" --fields "DAPI BEN VAS OXY" --dtype uint8
python /Users/cam/code/ir/trunk/bin/Scripts/createidx.py --visus /Users/cam/code/ir/trunk/bin/visus/osx/visusconvert --dims "8517 9240 14" --name "idx/0003-ntdata.idx" --fields "DAPI BEN VAS OXY" --dtype uint8
python /Users/cam/code/ir/trunk/bin/Scripts/createidx.py --visus /Users/cam/code/ir/trunk/bin/visus/osx/visusconvert --dims "8517 9240 11" --name "idx/0004-ntdata.idx" --fields "DAPI BEN VAS OXY" --dtype uint8
python /Users/cam/code/ir/trunk/bin/Scripts/createidx.py --visus /Users/cam/code/ir/trunk/bin/visus/osx/visusconvert --dims "8517 9240 13" --name "idx/0005-ntdata.idx" --fields "DAPI BEN VAS OXY" --dtype uint8
ir-stom -remap -base-mask -pad 1500 650 0 2500 -load mytweak0002_0001_brute.stos mytweak0003_0002_brute.stos mytweak0004_0003_brute.stos mytweak0005_0004_brute.stos -slice_dirs 0001/ 0002/ 0003/ 0004/ 0005/ -image_dirs 0 0001-0003/C01/001,0001-0004/C01/001,0001-0005/C01/001,0001-0006/C01/001,0001-0007/C01/001,0001-0008/C01/001,0001-0009/C01/001,0001-0010/C01/001,0001-0011/C01/001,0001-0012/C01/001,0001-0013/C01/001,0001-0014/C01/001,0001-0015/C01/001,0001-0016/C01/001,0001-0017/C01/001,0001-0018/C01/001 1 0002-0004/C01/001,0002-0005/C01/001,0002-0006/C01/001,0002-0007/C01/001,0002-0008/C01/001,0002-0009/C01/001,0002-0010/C01/001,0002-0011/C01/001,0002-0012/C01/001,0002-0013/C01/001,0002-0014/C01/001,0002-0015/C01/001,0002-0016/C01/001 2 0003-0004/C01/001,0003-0005/C01/001,0003-0006/C01/001,0003-0007/C01/001,0003-0008/C01/001,0003-0009/C01/001,0003-0010/C01/001,0003-0011/C01/001,0003-0012/C01/001,0003-0013/C01/001,0003-0014/C01/001,0003-0015/C01/001,0003-0016/C01/001,0003-0017/C01/001 3 0004-0001/C01/001,0004-0002/C01/001,0004-0003/C01/001,0004-0004/C01/001,0004-0005/C01/001,0004-0006/C01/001,0004-0007/C01/001,0004-0008/C01/001,0004-0009/C01/001,0004-0010/C01/001,0004-0011/C01/001 4 0005-0003/C01/001,0005-0004/C01/001,0005-0005/C01/001,0005-0006/C01/001,0005-0007/C01/001,0005-0008/C01/001,0005-0009/C01/001,0005-0010/C01/001,0005-0011/C01/001,0005-0012/C01/001,0005-0013/C01/001,0005-0014/C01/001,0005-0015/C01/001 -save ./idx/0001-ntdata ./idx/0002-ntdata ./idx/0003-ntdata ./idx/0004-ntdata ./idx/0005-ntdata -extension .idx -channel 0
ir-stom -remap -base-mask -pad 1500 650 0 2500 -load mytweak0002_0001_brute.stos mytweak0003_0002_brute.stos mytweak0004_0003_brute.stos mytweak0005_0004_brute.stos -slice_dirs 0001/ 0002/ 0003/ 0004/ 0005/ -image_dirs 0 0001-0003/C02/001,0001-0004/C02/001,0001-0005/C02/001,0001-0006/C02/001,0001-0007/C02/001,0001-0008/C02/001,0001-0009/C02/001,0001-0010/C02/001,0001-0011/C02/001,0001-0012/C02/001,0001-0013/C02/001,0001-0014/C02/001,0001-0015/C02/001,0001-0016/C02/001,0001-0017/C02/001,0001-0018/C02/001 1 0002-0004/C02/001,0002-0005/C02/001,0002-0006/C02/001,0002-0007/C02/001,0002-0008/C02/001,0002-0009/C02/001,0002-0010/C02/001,0002-0011/C02/001,0002-0012/C02/001,0002-0013/C02/001,0002-0014/C02/001,0002-0015/C02/001,0002-0016/C02/001 2 0003-0004/C02/001,0003-0005/C02/001,0003-0006/C02/001,0003-0007/C02/001,0003-0008/C02/001,0003-0009/C02/001,0003-0010/C02/001,0003-0011/C02/001,0003-0012/C02/001,0003-0013/C02/001,0003-0014/C02/001,0003-0015/C02/001,0003-0016/C02/001,0003-0017/C02/001 3 0004-0001/C02/001,0004-0002/C02/001,0004-0003/C02/001,0004-0004/C02/001,0004-0005/C02/001,0004-0006/C02/001,0004-0007/C02/001,0004-0008/C02/001,0004-0009/C02/001,0004-0010/C02/001,0004-0011/C02/001 4 0005-0003/C02/001,0005-0004/C02/001,0005-0005/C02/001,0005-0006/C02/001,0005-0007/C02/001,0005-0008/C02/001,0005-0009/C02/001,0005-0010/C02/001,0005-0011/C02/001,0005-0012/C02/001,0005-0013/C02/001,0005-0014/C02/001,0005-0015/C02/001 -save ./idx/0001-ntdata ./idx/0002-ntdata ./idx/0003-ntdata ./idx/0004-ntdata ./idx/0005-ntdata -extension .idx -channel 1
ir-stom -remap -base-mask -pad 1500 650 0 2500 -load mytweak0002_0001_brute.stos mytweak0003_0002_brute.stos mytweak0004_0003_brute.stos mytweak0005_0004_brute.stos -slice_dirs 0001/ 0002/ 0003/ 0004/ 0005/ -image_dirs 0 0001-0003/C03/001,0001-0004/C03/001,0001-0005/C03/001,0001-0006/C03/001,0001-0007/C03/001,0001-0008/C03/001,0001-0009/C03/001,0001-0010/C03/001,0001-0011/C03/001,0001-0012/C03/001,0001-0013/C03/001,0001-0014/C03/001,0001-0015/C03/001,0001-0016/C03/001,0001-0017/C03/001,0001-0018/C03/001 1 0002-0004/C03/001,0002-0005/C03/001,0002-0006/C03/001,0002-0007/C03/001,0002-0008/C03/001,0002-0009/C03/001,0002-0010/C03/001,0002-0011/C03/001,0002-0012/C03/001,0002-0013/C03/001,0002-0014/C03/001,0002-0015/C03/001,0002-0016/C03/001 2 0003-0004/C03/001,0003-0005/C03/001,0003-0006/C03/001,0003-0007/C03/001,0003-0008/C03/001,0003-0009/C03/001,0003-0010/C03/001,0003-0011/C03/001,0003-0012/C03/001,0003-0013/C03/001,0003-0014/C03/001,0003-0015/C03/001,0003-0016/C03/001,0003-0017/C03/001 3 0004-0001/C03/001,0004-0002/C03/001,0004-0003/C03/001,0004-0004/C03/001,0004-0005/C03/001,0004-0006/C03/001,0004-0007/C03/001,0004-0008/C03/001,0004-0009/C03/001,0004-0010/C03/001,0004-0011/C03/001 4 0005-0003/C03/001,0005-0004/C03/001,0005-0005/C03/001,0005-0006/C03/001,0005-0007/C03/001,0005-0008/C03/001,0005-0009/C03/001,0005-0010/C03/001,0005-0011/C03/001,0005-0012/C03/001,0005-0013/C03/001,0005-0014/C03/001,0005-0015/C03/001 -save ./idx/0001-ntdata ./idx/0002-ntdata ./idx/0003-ntdata ./idx/0004-ntdata ./idx/0005-ntdata -extension .idx -channel 2
ir-stom -remap -base-mask -pad 1500 650 0 2500 -load mytweak0002_0001_brute.stos mytweak0003_0002_brute.stos mytweak0004_0003_brute.stos mytweak0005_0004_brute.stos -slice_dirs 0001/ 0002/ 0003/ 0004/ 0005/ -image_dirs 0 0001-0003/C04/001,0001-0004/C04/001,0001-0005/C04/001,0001-0006/C04/001,0001-0007/C04/001,0001-0008/C04/001,0001-0009/C04/001,0001-0010/C04/001,0001-0011/C04/001,0001-0012/C04/001,0001-0013/C04/001,0001-0014/C04/001,0001-0015/C04/001,0001-0016/C04/001,0001-0017/C04/001,0001-0018/C04/001 1 0002-0004/C04/001,0002-0005/C04/001,0002-0006/C04/001,0002-0007/C04/001,0002-0008/C04/001,0002-0009/C04/001,0002-0010/C04/001,0002-0011/C04/001,0002-0012/C04/001,0002-0013/C04/001,0002-0014/C04/001,0002-0015/C04/001,0002-0016/C04/001 2 0003-0004/C04/001,0003-0005/C04/001,0003-0006/C04/001,0003-0007/C04/001,0003-0008/C04/001,0003-0009/C04/001,0003-0010/C04/001,0003-0011/C04/001,0003-0012/C04/001,0003-0013/C04/001,0003-0014/C04/001,0003-0015/C04/001,0003-0016/C04/001,0003-0017/C04/001 3 0004-0001/C04/001,0004-0002/C04/001,0004-0003/C04/001,0004-0004/C04/001,0004-0005/C04/001,0004-0006/C04/001,0004-0007/C04/001,0004-0008/C04/001,0004-0009/C04/001,0004-0010/C04/001,0004-0011/C04/001 4 0005-0003/C04/001,0005-0004/C04/001,0005-0005/C04/001,0005-0006/C04/001,0005-0007/C04/001,0005-0008/C04/001,0005-0009/C04/001,0005-0010/C04/001,0005-0011/C04/001,0005-0012/C04/001,0005-0013/C04/001,0005-0014/C04/001,0005-0015/C04/001 -save ./idx/0001-ntdata ./idx/0002-ntdata ./idx/0003-ntdata ./idx/0004-ntdata ./idx/0005-ntdata -extension .idx -channel 3
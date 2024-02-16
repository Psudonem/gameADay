while True:
      spname = input("SPNAME:")
      print(spname+"H = _CopyImage("+spname+", 33)")
      print("_FreeImage "+spname)

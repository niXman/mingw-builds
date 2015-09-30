
define {
    CBN_SELCHANGE = 1
    
    CB_RESETCONTENT = 0x014B
    
    IDVER = 3501
    IDARCH = 3503
    IDTHREAD = 3505
    IDEXCEPT = 3507
    IDBUILD = 3509
}

global {
   arrstr versions
   hash vers of arr
   arrstr lines
   arrstr archis 
   hash archs of arr
   arrstr threadis 
   hash threads of arr
   arrstr exceptis 
   hash excepts of arr
   arrstr buildis 
   hash builds of arr
   str garch
}

func int versort( uint left right )
{
   left as str
   right as str

   if left < right: return 1
   if left > right: return -1
   return 0
}

func int buildsort( uint left right )
{
   left as str
   right as str

   if int( left ) < int( right ): return 1
   if int( left ) > int( right ): return -1
   return 0
}

func loadversions()
{
   str in
   uint i
   
   macrox_getstr( "repo", in )
   in.lines( lines, 1 )
    
   fornum i, *lines
   {
      arrstr items
      lines[i].split( items, '|', $SPLIT_EMPTY | $SPLIT_NOSYS )
      if *items < 6 : continue
      if !vers.find( items[0] )
      {
         vers.create( items[0] )
         versions += items[0]
      }
      vers[ items[0] ][ vers[items[0]].expand(1) ] = i      
   }
   versions->arr.sort( &versort )
   str ver_list
   fornum i=0, *versions
   {
      ver_list += "\(versions[i])=\(versions[i])\l"
   }
   macrox_setstr( "vers_list", ver_list )  

   str progfiles progfiles64
   uint off

   macrox_do( progfiles="#progfiles#")
   off = progfiles.findchr('(')
   if ( off < *progfiles )
   {
      progfiles64.substr( progfiles, 0, off-1 )
      macrox_setstr( "progfiles64", progfiles64 )
   }
   else : macrox_setstr( "progfiles64", progfiles )
}

func load_combo( uint combo, arrstr alist )
{
   uint i
   if &alist == &buildis : alist->arr.sort( &buildsort )
   else: alist.sort( 1 )
   fornum  i, *alist : SendMessage( combo, $CB_ADDSTRING, 0, alist[i].ptr() )
   SendMessage( combo, $CB_SETCURSEL, 0, 0 )
}

func load_hash( uint combo, arrstr alist, hash ahash of arr, arr alines, uint num )
{
   uint i
   SendMessage( combo, $CB_RESETCONTENT, 0, 0 )
   alist.clear()
   ahash.clear()
   fornum i, *alines
   {
      arrstr items
      
      lines[ alines[i]].split( items, '|', $SPLIT_EMPTY | $SPLIT_NOSYS )
      if *items < 6 : continue
      if !macrox_getint("os64") && items[num] == "x86_64" : continue
      
      if !ahash.find( items[num] )
      {
         ahash.create( items[num] )
         if num == 4 : items[num].replace( "rev", "", $QS_IGNCASE ) 
         alist += items[num]
      }
      ahash[ items[num] ][ ahash[items[num]].expand(1) ] = alines[i]      
   }
}

func buildchange( uint wnd )
{
   uint cursel = SendMessage( GetDlgItem( wnd, $IDBUILD ), $CB_GETCURSEL, 0, 0 )
   str curver = buildis[cursel]
   arrstr items
   lines[ builds[curver][0]].split( items, '|', $SPLIT_EMPTY | $SPLIT_NOSYS )

   str filename original ext
   items[5].fgetparts( 0->str, filename, ext )
   uint off = filename.findchr( '/' ) + 1
   filename.substr( off, *filename - off )
   (original = filename) += ".\(ext)"
   filename.replace("release-", "", $QS_IGNCASE )
   macrox_setstr("progname", filename )
   macrox_setstr("shfolder", "#shgroup#\\\(filename)" )
   

   if garch %== "x86_64" : macrox_setstr("setuppath", "#progfiles64#\\mingw-w64\\\(filename)" )
   else : macrox_setstr("setuppath", "#progfiles#\\mingw-w64\\\(filename)" )

   str stemp = items[5].replace("sourceforge","downloads.sourceforge", $QS_IGNCASE )
   stemp += "?r=&ts=1367578968&use_mirror=garr"
   stemp.replace("/i686/","/32-bit/", $QS_IGNCASE )
   stemp.replace("/x86_64/","/64-bit/", $QS_IGNCASE )
   //macrox_setint("app64", filename.search( "x86_64", $QS_IGNCASE ))
   stemp.replace("files/","", $QS_IGNCASE )
   stemp.replace("projects/","project/", $QS_IGNCASE )
   stemp.replace("release/","releases/", $QS_IGNCASE )
//   macrox_setstr("urlapp", items[5].replace("sourceforge","garr.dl.sourceforge", $QS_IGNCASE ) )
   macrox_setstr("urlapp", stemp )
   macrox_setstr("originalfile", original )
//   print("\(filename) == \(original)")
   
/*   print( stemp )
   print("\l 
http://downloads.sourceforge.net/project/mingwbuilds/host-windows/releases/4.6.2/32-bit/threads-posix/dwarf/x32-4.6.2-release-posix-dwarf-rev0.7z?r=&ts=1367578968&use_mirror=garr")*/
//   macrox_setstr("urlapp", "http://downloads.sourceforge.net/project/mingwbuilds/host-windows/releases/4.6.2/32-bit/threads-posix/dwarf/x32-4.6.2-release-posix-dwarf-rev0.7z?r=&ts=1367578968&use_mirror=garr" )
/*  http://downloads.sourceforge.net/project/mingwbuilds/host-windows/releases/4.8.0/64-bit/threads-posix/seh/x64-4.8.0-release-posix-seh-rev2.7z?r=&ts=1367579123&use_mirror=kaz*/
//   macrox_setstr("urlapp", "\(items[5])/download?use_mirror=garr" )
//   macrox_setstr("urlapp", items[5] )
      
}

func exceptchange( uint wnd )
{
   uint combo = GetDlgItem( wnd, $IDBUILD )
   uint cursel = SendMessage( GetDlgItem( wnd, $IDEXCEPT ), $CB_GETCURSEL, 0, 0 )
   str curver = exceptis[cursel]
      
   load_hash( combo, buildis, builds, excepts[curver], 4 )
   load_combo( combo, buildis )

   buildchange( wnd )        
}

func threadchange( uint wnd )
{
   uint combo = GetDlgItem( wnd, $IDEXCEPT )
   uint cursel = SendMessage( GetDlgItem( wnd, $IDTHREAD ), $CB_GETCURSEL, 0, 0 )
   str curver = threadis[cursel]
   load_hash( combo, exceptis, excepts, threads[curver], 3 )
   load_combo( combo, exceptis )

   exceptchange( wnd )        
}

func archchange( uint wnd )
{
   uint combo = GetDlgItem( wnd, $IDTHREAD )
   uint cursel = SendMessage( GetDlgItem( wnd, $IDARCH ), $CB_GETCURSEL, 0, 0 )
   str curver = archis[cursel]
/*   uint i
   fornum i, *archs[ curver ]
   {
      print("\( lines[ archs[ curver ][i]])\l")
   }   */
   garch = curver
   load_hash( combo, threadis, threads, archs[curver], 2 )
   load_combo( combo, threadis )
   threadchange( wnd )        
}

func verchange( uint wnd )
{
   uint combo = GetDlgItem( wnd, $IDARCH )
   str  curver
    
   uint cursel = SendMessage( GetDlgItem( wnd, $IDVER ), $CB_GETCURSEL, 0, 0 )
   curver = versions[cursel]
/*   uint i
   fornum i, *vers[ curver ]
   {
      print("\( lines[ vers[ curver ][i]])\l")
   }*/   

   load_hash( combo, archis, archs, vers[curver], 1 )
   load_combo( combo, archis )
   archchange( wnd )        
}

func calcsize()
{
/*   uint ret
   str  head
   httpinfo hi

   head.reserve( 1024 )   
   ret = http_head( macrox_do("#redirurl#"), head, hi )
   macrox_setint("filesize", uint( hi.size ))
   print( hi.size )
   print( head )
   print("ret = \( ret )")*/
   macrox_setint( "dwn_nofile", 1 )
   macrox_setint( "dwn_progsize", 1 )
   /*   cmn_progsize += long( hi.size )
   percent = cmn_progcursize * 100L / cmn_progsize
   cmn_percent = percent
   wprogress_setpos( cmn_progress, uint( percent ))*/ 

   str stemp sdir
   macrox_getstr("setuppath", stemp )
   sdir.fgetdir( stemp ) 
   verifypath( sdir, 0->arrstr )
}

func uint vercmdproc( uint wnd id ctl codedlg )
{
   uint ret
//   print("\(id)=\( $IDVER)=\(ctl)=\(codedlg)\n")
   if codedlg == $CBN_SELCHANGE
   {
      switch id {
         case $IDVER : verchange( wnd )
         case $IDARCH : archchange( wnd )
         case $IDTHREAD : threadchange( wnd )
         case $IDEXCEPT : exceptchange( wnd )
         case $IDBUILD : buildchange( wnd )
      }
   }
   ret = dlgsetscmdproc( wnd, id, ctl, codedlg )
   switch id {
      case $DLGINIT : verchange( wnd )
//      case $IDC_PREV : print("Press Prev\n")
//      case $IDC_NEXT : print("Press Next\n")
   }
   
   return ret
}

func getdirname()
{
   str dirname
   ffind fd

   macrox_getstr("setuppath", dirname)
   fd.init( "\(dirname)\\*.*", $FIND_DIR )
   foreach finfo cur,fd
   {
      if cur.name == "." && cur.name == ".." : continue
      dirname = cur.name
      break
   }
   macrox_setstr("dirname", dirname )
}

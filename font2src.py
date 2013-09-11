#!/usr/bin/env python
#coding:utf-8
# Author:  Sir Garbagetruck/Accession --<truck@notonfire.co.uk>
# Purpose: Convert DMG's raw fonts to data for code
# Created: 25/02/13

import sys
import getopt

class Usage(Exception):
    def __init__(self,msg):
        self.msg = msg
        print """
Usage:
-f or --file: input filename (a dmg raw font)
 (I suppose you could use this for something else (:  )
-o, --output: output filename (writes to this file)
 unneeded for dumping to stdout
 will clobber the file (overwrites)
-a, --append: append output, don't overwrite file.
-v, --var, --variable: use this variable name in output
        """

def split_by_n(seq,n):
    """generator to divide sequency by n chunks (Russel Borogove)"""
    while seq:
        yield seq[:n]
        seq = seq[n:]


def dumpfile(infile,outfile="+none+",noclobber=False,varname="font"):
    if noclobber:
        writemode = "a"
    else:
        writemode = "w"
    if outfile != "+none+":
        sys.stdout = open(outfile,writemode)
    font = open(infile).read()
    fnt = list(split_by_n(font,16))

    print(varname + "= [")
    chk = 0
    for chardef in fnt:
        print "    [",
        chk2 = 0
        line = ""
        for char in chardef:
            line += "0x%0.2X" % ord(char)
            chk2 += 1
            if chk2 < 16:
                line += ","
        line += " ]"
        chk += 1
        if chk < len(fnt):
            line += ","
        print line
    print("];")



def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:],"hf:o:a:v:",["help","file",
                                                        "output","append",
                                                        "var","variable"])
        except getopt.error,msg:
            raise Usage(msg)
        outfile = "+none+"
        noclobber = False
        varname = "font"
        for o,a in opts:
            if o in ("-h","--help"):
                usage()
            elif o in ("-f","--file"):
                filename = a
                print a
            elif o in ("-o","--output"):
                outfile = a
            elif o in ("-a","--append"):
                noclobber=True
            elif o in ("-v","--var","--variable"):
                varname = a
        dumpfile(filename,outfile,noclobber,varname)

    except Usage,err:
        print >>sys.stderr,err.msg
        print >>sys.stderr, "for help use --help"
        return 2


if __name__=='__main__':
    sys.exit(main())
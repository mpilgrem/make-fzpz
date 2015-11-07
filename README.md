# make-fzpz

## Introduction

The [Fritzing](http://fritzing.org/home/) software tool allows users to document
their electronics prototypes, including by creating their own parts.

This project seeks to provide Windows tools to create a bundle (\*.fzpz) file
from a part metadata (\*.fzp) file and its associated vector graphics (\*.svg)
files.

The tools assume that the metadata file is in subdirectory `\part` and the
vector graphics files are in subdirectories of subdirectory `\svg`.

## Bundle file format

The format of the bundle file is a zip file containing the metadata file and
associated vector graphics files. The name of the metadata file begins `part.`.
The name of each vector graphics file begins `svg.<view>.`, where `<view>` is
one of icon, breadboard, schematic and pcb.

## Windows PowerShell Version 4 or higher

`make-fzpz.ps1` is a Windows PowerShell script, requiring version 4.0 or higher.
Specifically, it makes use of the `System.IO.Compression.ZipFile` class provided
by .NET Framework 4.5 or higher.

## Windows batch file

`make-fzpz.bat` is a Windows batch file. It reqires application
[7-Zip](http://www.7-zip.org/) (`7z.exe`) to be in the path.
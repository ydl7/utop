(*
 * setup.ml
 * --------
 * Copyright : (c) 2012, Jeremie Dimino <jeremie@dimino.org>
 * Licence   : BSD3
 *
 * This file is a part of utop.
 *)

(* OASIS_START *)
(* DO NOT EDIT (digest: a426e2d026defb34183b787d31fbdcff) *)
(******************************************************************************)
(* OASIS: architecture for building OCaml libraries and applications          *)
(*                                                                            *)
(* Copyright (C) 2011-2016, Sylvain Le Gall                                   *)
(* Copyright (C) 2008-2011, OCamlCore SARL                                    *)
(*                                                                            *)
(* This library is free software; you can redistribute it and/or modify it    *)
(* under the terms of the GNU Lesser General Public License as published by   *)
(* the Free Software Foundation; either version 2.1 of the License, or (at    *)
(* your option) any later version, with the OCaml static compilation          *)
(* exception.                                                                 *)
(*                                                                            *)
(* This library is distributed in the hope that it will be useful, but        *)
(* WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY *)
(* or FITNESS FOR A PARTICULAR PURPOSE. See the file COPYING for more         *)
(* details.                                                                   *)
(*                                                                            *)
(* You should have received a copy of the GNU Lesser General Public License   *)
(* along with this library; if not, write to the Free Software Foundation,    *)
(* Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA              *)
(******************************************************************************)

let () =
  try
    Topdirs.dir_directory (Sys.getenv "OCAML_TOPLEVEL_PATH")
  with Not_found -> ()
;;
#use "topfind";;
#require "oasis.dynrun";;
open OASISDynRun;;

let setup_t = BaseCompat.Compat_0_4.adapt_setup_t setup_t
open BaseCompat.Compat_0_4
(* OASIS_STOP *)

let search_compiler_libs () =
  prerr_endline "I: Searching for OCaml compiler libraries";
  let stdlib = BaseEnv.var_get "standard_library" in
  let ( / ) = Filename.concat in
  try
    List.find (fun path -> Sys.file_exists (path / "types.cmi") || Sys.file_exists (path / "typing" / "types.cmi")) [
      stdlib;
      stdlib / "compiler-libs";
      stdlib / "compiler-lib";
      stdlib / ".." / "compiler-libs";
      stdlib / ".." / "compiler-lib";
    ]
  with Not_found ->
    prerr_endline "E: Cannot find compiler libraries! See the README for details.";
    exit 1

let compiler_libs =
  BaseEnv.var_define
    ~short_desc:(fun () -> "compiler libraries")
    "compiler_libs"
    search_compiler_libs

let () = setup ()

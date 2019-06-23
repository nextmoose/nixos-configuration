#!/usr/bin/env bats

@test "configure-nixos with out arguments" {
    run configure-nixos 
    [ "${status}" == 64 ] &&
	[ "${output}" == "Unspecified SALT" ] &&
	true
}

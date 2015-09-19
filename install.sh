#!/bin/bash

die() {
	msg="$1"
	echo "$msg" >&2
	exit 1
}

simpleddScript=simpledd
binDir=/usr/local/bin
nautilusScriptDir="${HOME}/.local/share/nautilus/scripts"
nautilusScript="${nautilusScriptDir}/SimpleDD"

if [[ ! -d $nautilusScriptDir ]]; then
	echo "Creando: $nautilusScriptDir"
	mkdir -p $nautilusScriptDir 2>/dev/null || \
		die "Error al crear el directorio: $nautilusScriptDir"
fi

if [[ -f $nautilusScript ]]; then
	read -n1 -p "Desea sobreescribir $nautilusScript (S/N): " opt
	[[ $opt =~ [Ss] ]] || die "Saliendo..."
fi

echo "Copiando: $simpleddScript -> $binDir"
sudo cp $simpleddScript $binDir 2>/dev/null || die "Error"

echo "Cambiando permisos"
sudo chown root:root ${binDir}/${simpleddScript} 2>/dev/null || die "Error"
sudo chmod 755 ${binDir}/${simpleddScript} 2>/dev/null || die "Error"

echo "Creando: $nautilusScript"
cat << EOF > "$nautilusScript"
#!/bin/bash

pkexec env DISPLAY=\$DISPLAY XAUTHORITY=\$XAUTHORITY NAUTILUS_SCRIPT_SELECTED_FILE_PATHS="\$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ${binDir}/${simpleddScript} "\$1"
EOF

chmod 755 "$nautilusScript"

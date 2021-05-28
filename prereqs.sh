get_distribution() {
	lsb_dist=""
	if [ -r /etc/os-release ]; then
		lsb_dist="$(. /etc/os-release && echo "$ID")"
	fi
	echo "$lsb_dist"
}

#detect version
lsb_dist=$( get_distribution )
lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"
sh_c='sh -c'
#prerequisites to be installed
pre_reqs="texlive pandoc texlive-latex-extra texlive-fonts-recommended librsvg2-bin texlive-fonts-extra"
#install dependancies
case "$lsb_dist" in
    ubuntu|debian|raspbian)
        (
            $sh_c 'apt-get update -qq >/dev/null'
            $sh_c "apt-get install -y -qq $pre_reqs >/dev/null"
        )
        ;;

    centos|fedora|rhel)
        if [ "$lsb_dist" = "fedora" ]; then
            pkg_manager="dnf"
        else
            pkg_manager="yum"
        fi
        (
            $sh_c "$pkg_manager install -y -q $pre_reqs"
        )
        ;;

    *)
        echo
        echo "ERROR: Unsupported distribution '$lsb_dist'"
        echo
        exit 1
        ;;
esac
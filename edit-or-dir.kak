define-command edit-or-dir -file-completion -params .. %{
    evaluate-commands %sh{
        echo "try %{ delete-buffer! *dir* }"
        arg="$1"
        [ -z "$arg" ] && arg=$(pwd)
        if [ -d "$arg" ]; then
            pwd=$(pwd)
            case "$1" in
                '')  dir="$pwd" ;;
                /*)  dir="$arg" ;;
                ..*) dir="$pwd/$arg"
                     prev="/${pwd##*/}<ret>;" ;;
                *)   dir="$pwd/$arg" ;;
            esac
            echo "change-directory %{$dir}"
            echo "edit-or-dir-display-dir %{$arg}"
            echo "try %{ execute-keys %{$prev}}"
        else
            echo "edit %{$*}"
        fi
    }
}

declare-option -hidden str edit_or_dir_hidden ''

define-command -hidden -params 1 edit-or-dir-display-dir %{
    edit -scratch *dir*
    set-option window filetype 'file_select'
    evaluate-commands %sh{
        keys="ls<space>$kak_opt_edit_or_dir_hidden<space>-p<space>--group-directories-first<space><ret>xd"
        if [ -z $kak_opt_edit_or_dir_hidden ]; then
            keys="!echo<space>../<space>&&<space> $keys gg"
        else
            keys="!"$keys"ggxd"
        fi
        echo "execute-keys '$keys'"
    }
}

hook global WinSetOption filetype=file_select %{
    map window normal <ret> %{ x_:<space>edit-or-dir<space>'<c-r>.'<ret> }
    map window normal <backspace> %{ :<space>edit-or-dir<space>..<ret> }
    map window normal <esc> %{ :<space>db<ret> }
    map window normal <a-h> %{ :<space>edit-or-dir-toggle-hidden<ret> }
    add-highlighter window/dir regex '^.+/$' 0:list
}

define-command -hidden edit-or-dir-toggle-hidden %{
    evaluate-commands %sh{
        if [ -z $kak_opt_edit_or_dir_hidden ]; then
            echo "set-option global edit_or_dir_hidden '-a'"
        else
            echo "set-option global edit_or_dir_hidden ''"
        fi
        echo "edit-or-dir"
    }
}


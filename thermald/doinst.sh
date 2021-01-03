update() {
  new_file="$1"
  old_file=$(echo "$new_file" | sed 's/\.new$//')

  if [ ! -f $old_file ]; then
    # Old file doesn't exist, then just move it over.
    mv $new_file $old_file
  else
    old_md5=$(md5sum $old_file | cut -d ' ' -f 1)
    new_md5=$(md5sum $new_file | cut -d ' ' -f 1)
    # Same file, just remove the new one.
    if [ "$old_md5" == "$new_md5" ]; then
      rm $new_file
    fi
  fi

  # Keep new file so admin is asked what to do.
}

update_with_perms() {
  new_file="$1"
  old_file=$(echo "$new_file" | sed 's/\.new$//')

  if [ -f $old_file ]; then
    old_perms=$(stat -c '%a' "$old_file")
    chmod $old_perms $new_file
  fi

  update $new_file
}

update '/etc/thermald/thermal-cpu-cdev-order.xml.new'
update '/etc/rc.d/rc.thermald.new'

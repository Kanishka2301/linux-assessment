
if [ $# -ne 3 ]; then
  echo "Usage: $0 <source_dir> <backup_dir> <extension>"
  exit 1
fi

SOURCE_DIR="$1"
BACKUP_DIR="$2"
EXTENSION="$3"

export BACKUP_COUNT=0
TOTAL_SIZE=0


if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory does not exist"
  exit 1
fi


if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
fi


shopt -s nullglob
FILES=("$SOURCE_DIR"/*."$EXTENSION")


if [ ${#FILES[@]} -eq 0 ]; then
  echo "No files with .$EXTENSION found in source directory"
  exit 1
fi

echo "Files to be backed up:"
for file in "${FILES[@]}"; do
  size=$(stat -c%s "$file")
  echo "$(basename "$file") - $size bytes"
done


for file in "${FILES[@]}"; do
  base=$(basename "$file")
  dest="$BACKUP_DIR/$base"

  if [ -f "$dest" ]; then
    if [ "$file" -nt "$dest" ]; then
      cp "$file" "$dest"
    fi
  else
    cp "$file" "$dest"
  fi

  size=$(stat -c%s "$file")
  TOTAL_SIZE=$((TOTAL_SIZE + size))
  BACKUP_COUNT=$((BACKUP_COUNT + 1))
done


REPORT="$BACKUP_DIR/backup_report.log"
{
  echo "Backup Summary Report"
  echo "---------------------"
  echo "Total files processed: $BACKUP_COUNT"
  echo "Total size backed up: $TOTAL_SIZE bytes"
  echo "Backup directory: $BACKUP_DIR"
} > "$REPORT"

echo "Backup completed successfully"


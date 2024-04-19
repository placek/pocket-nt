s/<n>[^<]*<\/n>//g            # remove all notes
s/<S>[^<]*<\/S>//g            # remove all strong codes
s/<m>[^<]*<\/m>//g            # remove all grammar codes
s/<[^>]*>//g                  # remove all tag begginings
s/<\/[^>]*>//g                # remove all tag endings
s/\*//g                       # remove all asterisks
s/\[[0-9]*\]//g               # remove all numbers in square brackets
s/\s+/ /g                     # remove extra whitespaces
s/\s+([,\.\?:;!\]\)\}»])/\1/g # remove whitespaces before punctuation and closing brackets
s/([\(\{\[«])\s+/\1/g         # remove whitespaces after opening brackets

s/^[0-9]*\|([^|]*)\|1\|([^|]*)\|([^|]*)$/<book data-book="\1"><chapter data-chapter="1"><column class="left">\2<\/column><column class="right">\3<\/column><\/chapter>/
s/^[0-9]*\|[^|]*\|([^|]*)\|([^|]*)\|([^|]*)$/<chapter data-chapter="\1"><column class="left">\2<\/column><column class="right">\3<\/column><\/chapter>/
s/\{\{/</g
s/\}\}/>/g
s/\b(z|do|na|przy|bez|dla|nad|pod|przed|po|w|o|u|ku|za|a|i|oraz|ale|lecz|czy|czyli|więc|bo|się|ci|mu|mi|jej|jemu|mnie|tobie|sobie|kto|co|który|która|które|jak|gdzie) /\1\&nbsp;/gI

$a</book>

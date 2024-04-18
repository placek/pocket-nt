ATTACH DATABASE 'left.db' AS db1;
ATTACH DATABASE 'right.db' AS db2;

WITH
  AllVersesD1 AS (
    SELECT
      b.book_number,
      b.long_name AS book,
      v.chapter,
      v.verse,
      v.text
    FROM
      db1.verses AS v
    JOIN
      db1.books AS b
    ON
      v.book_number = b.book_number
    WHERE
      b.book_number >= 470
    ORDER BY b.book_number, v.chapter, v.verse
  ),
  AllVersesD2 AS (
    SELECT
      b.book_number,
      b.long_name AS book,
      v.chapter,
      v.verse,
      v.text
    FROM
      db2.verses AS v
    JOIN
      db2.books AS b
    ON
      v.book_number = b.book_number
    WHERE
      b.book_number >= 470
    ORDER BY b.book_number, v.chapter, v.verse
  ),
  AllChaptersD1 AS (
    SELECT
      book_number,
      book,
      chapter,
      GROUP_CONCAT('{{verse data-verse="' || verse || '"}}' || text || '{{/verse}}', '') AS verses
    FROM
      AllVersesD1
    GROUP BY book_number, chapter
  ),
  AllChaptersD2 AS (
    SELECT
      book_number,
      book,
      chapter,
      GROUP_CONCAT('{{verse data-verse="' || verse || '"}}' || text || '{{/verse}}', '') AS verses
    FROM
      AllVersesD2
    GROUP BY book_number, chapter
  )
SELECT
  v1.book_number,
  v1.book,
  v1.chapter,
  v1.verses AS left,
  v2.verses AS right
FROM AllChaptersD1 AS v1
JOIN AllChaptersD2 AS v2
ON v1.book_number = v2.book_number AND v1.chapter = v2.chapter;

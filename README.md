# ex_browseviewsort
Example illustrating how you can take the sorting applied in a DISPLAY ARRAY and apply it to the underlying 4gl array

This example arose out of this forum discussion http://4js.com/fjs_forum/index.php?topic=1289.  Could I display an array in a DISPLAY ARRAY, sort it, and then display it in a MENU/FIRST/PREVIOUS/NEXT/LAST pattern in the same order

So in this example, I have a MENU that displays a record at a time
![Menu View Before](https://user-images.githubusercontent.com/13615993/45337917-a0cda900-b5de-11e8-8e7b-cffd0a3d096d.png)

By clicking on Browse I can display in a DISPLAY ARRAY
![Display Array View](https://user-images.githubusercontent.com/13615993/45337918-a3300300-b5de-11e8-9ff8-ccf0a8549762.png)

I can then sort on a column, in this case Category
![Sort a Column](https://user-images.githubusercontent.com/13615993/45337931-b0e58880-b5de-11e8-8303-ab9eba7e8787.png)

I then select a row
![Select a Row](https://user-images.githubusercontent.com/13615993/45337933-b347e280-b5de-11e8-8123-eabbf4a1bd7c.png)

When I return to the MENU view, that selected row is current
![Return to Menu](https://user-images.githubusercontent.com/13615993/45337936-b7740000-b5de-11e8-8c60-6bef925542af.png)

and when I click next, the next sorted row appears
![Next/Previous etc use new sort order](https://user-images.githubusercontent.com/13615993/45337937-b9d65a00-b5de-11e8-9515-8af8484d08ef.png)

(Note the value of the ID field and how it was the next row in the table a few rows up)

The key technique being to use array.sort method to sort the array.  Rather than trying to figure out what sort column etc, as part of the ON SORT in the DISPLAY ARRAY I populated a (PHANTOM) column with the new sort position and use that column in the .sort method



IMPORT util
DEFINE arr DYNAMIC ARRAY OF RECORD
    id INTEGER,
    group CHAR(3),
    category CHAR(1),
    qty INTEGER,
    price DECIMAL(11,2),
    last_sold DATE,
    sort_idx INTEGER 
END RECORD

MAIN
DEFINE i INTEGER
DEFINE idx INTEGER

    DEFER INTERRUPT
    DEFER QUIT

    OPTIONS FIELD ORDER FORM
    OPTIONS INPUT WRAP
    
    CALL ui.Interface.loadStyles("ex_browseviewsort.4st")

    -- Populate random data
    FOR i = 1 TO 1000
        LET arr[i].id = i
        LET arr[i].group = random_letter(),random_letter(), random_letter()
        LET arr[i].category = random_letter()
        LET arr[i].qty = util.Math.rand(100)
        LET arr[i].price = (util.Math.rand(100000)+1)/100
        LET arr[i].last_sold = TODAY -util.math.rand(100)
        LET arr[i].sort_idx = i
    END FOR
    LET idx = 1
    CLOSE WINDOW SCREEN
    OPEN WINDOW w WITH FORM "ex_browseviewgrid"
    
    MENU ""
        BEFORE MENU
            DISPLAY BY NAME arr[idx].* 
            CALL state(DIALOG, idx, arr.getLength())
            
        ON ACTION first
            LET idx = 1
            DISPLAY BY NAME arr[idx].* 
            CALL state(DIALOG, idx, arr.getLength())
            
        ON ACTION last
            LET idx = arr.getLength()
            DISPLAY BY NAME arr[idx].*
            CALL state(DIALOG, idx, arr.getLength())
            
        ON ACTION previous
            LET idx = idx -1 
            IF idx < 1 THEN
                LET idx = 1
            END IF
            DISPLAY BY NAME arr[idx].*
            CALL state(DIALOG, idx, arr.getLength())
            
        ON ACTION browse
            -- Browse list in DISPLAY ARRAY with ON SORT
            CALL do_browse(idx) RETURNING idx
            
            -- Sort the array based on value in sort_idx
            CALL arr.sort("sort_idx", FALSE)

            -- Display selected value
            DISPLAY BY NAME arr[idx].*
            
            CALL state(DIALOG, idx, arr.getLength())  
            
        ON ACTION next
            LET idx = idx +1 
            IF idx > arr.getLength() THEN
                LET idx = arr.getLength()
            END IF
            DISPLAY BY NAME arr[idx].*  
            CALL state(DIALOG, idx, arr.getLength()) 
            
        ON ACTION close
            EXIT MENU
    END MENU
END MAIN


FUNCTION state(d, idx, len)
DEFINE d ui.Dialog
DEFINE idx, len INTEGER

    CALL d.setActionActive("first", idx > 1)
    CALL d.setActionActive("previous", idx > 1)
    CALL d.setActionActive("last", idx < len)
    CALL d.setActionActive("next", idx < len)
    MESSAGE SFMT("Row %1 of %2", idx, len)
END FUNCTION



FUNCTION do_browse(idx)
DEFINE i INTEGER
DEFINE idx INTEGER

    OPEN WINDOW b WITH FORM "ex_browseviewtable" ATTRIBUTES(STYLE="browse")  -- Use Style to force default settings

    DISPLAY ARRAY arr TO scr.* ATTRIBUTES(CANCEL=FALSE, ACCEPT=TRUE)
        BEFORE DISPLAY
            -- Populate sort_idx with current sorted position
            FOR i = 1 TO arr.getLength()
                LET arr[i].sort_idx = DIALOG.arrayToVisualIndex("scr",i)
            END FOR
            CALL DIALOG.setCurrentRow("scr",idx)
            
        ON SORT
            -- Populate sort_idx with new sorted position
            FOR i = 1 TO arr.getLength()
                LET arr[i].sort_idx = DIALOG.arrayToVisualIndex("scr",i)
            END FOR
            
        AFTER DISPLAY
            -- Determine the position of the current row 
            LET idx  = arr[arr_curr()].sort_idx
    END DISPLAY
    
    CLOSE WINDOW b
    RETURN idx
END FUNCTION



PRIVATE FUNCTION random_letter()
    RETURN ASCII(65+util.math.rand(26))
END FUNCTION
    
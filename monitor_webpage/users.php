<?php

    $connection = mysqli_connect("localhost", "vektor", "");

    // prepare sql
    $sql = "SELECT * FROM machinesdb.users";

    // find username
    $result = mysqli_query($connection, $sql);

    //$row = mysqli_fetch_array($result);

    // get number of rows in the table
    $rows_number = mysqli_num_rows($result);

    // fill the arrays with the rows data of stocks
    for ($i = 0; $i<$rows_number; $i++ )
    {
        $row = mysqli_fetch_array($result);
        $user_name[$i] = $row["user_name"];
        $tty[$i] = $row["tty"];
        $login_at[$i] = $row["login_at"];
        $idle[$i] = $row["idle"];
        $jcpu[$i] = $row["jcpu"];
        $pcpu[$i] = $row["pcpu"];
        $what[$i] = $row["what"];
        

    }
    


?>

<!DOCTYPE html>

<html>

  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
    <link href="css/styles.css" rel="stylesheet" type="text/css">
    <title>Users monitor</title>
  </head>

  <body>

    <div id="middle">  

        <h3>Users monitor</h3>

        <table style =" border-spacing: 18px; clear:both;">
            <tr>

                <th>UserName</th>      
                <th>TTY</th>        
                <th>LoginAt</th>          
                <th>Idle</th>         
                <th>jCPU</th>        
                <th>pCPU</th>       
                <th>What</th>    
                <th>Machine</th>    

         
            </tr>
            <?php for ($i = 0; $i < $rows_number; $i++) : ?>
            
            <tr>
                <td> <?= $user_name[$i]; ?> </td>
                <td> <?= $tty[$i]; ?> </td>
                <td> <?= $login_at[$i]; ?> </td>
                <td> <?= $idle[$i]; ?> </td>
                <td> <?= $jcpu[$i]; ?> </td>
                <td> <?= $pcpu[$i]; ?> </td>
                <td> <?= $what[$i]; ?> </td>
                <td>  <a href="/index.php">Machine</a> </td>

            </tr>

            <?php endfor ?>
        </table>
    </div>

  </body>

</html>

<?php

    // require common code and useful functions
    require_once("includes/common.php"); 
    require_once("includes/helpers.php");
    

    // prepare sql
    $sql = "SELECT * FROM machinesdb WHERE uid ='$uid'";

    // find username
    $result = mysqli_query($connection, $sql);

    // store username into $welcome_user and cash
    $row = mysqli_fetch_array($result);
    $welcome_user = $row["username"];
    $cash = $row["cash"];

    // prepare sql
    $sql = "SELECT * FROM stocks WHERE uid = '$uid'";

    // find all fields in stocks table
    $result = mysqli_query($connection, $sql);
    
    // get number of rows in the table
    $rows_number = mysqli_num_rows($result);

    // create two arrays to store data
    $symbol_array = array();
    $shares_array = array();

    // fill the arrays with the rows data of stocks
    for ($i = 0; $i<$rows_number; $i++ )
    {
        $row = mysqli_fetch_array($result);
        $symbol_array[$i] = $row["symbol"];
        $shares_array[$i] = $row["shares"];
    }


?>

<!DOCTYPE html>

<html>

  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
    <link href="css/styles.css" rel="stylesheet" type="text/css">
    <title>CC50 Finanças: Home</title>
  </head>

  <body>

    <div id="top">
        <img alt="CC50 Finanças" src="images/logo.png" style="height: 150px;">
    </div>
    
    <div id="middle">  

 

        <h3>Suas Ações</h3>


        <table style =" border-spacing: 18px; clear:both;">
            <tr>
                <th>Nome da companhia   </th>        
                <th>Quantidade de Ações  </th>          
                <th>Valorização/desvalorização</th>       
                <th>Preço atual US$</th>         
            </tr>
            <?php for ($i = 0; $i < $rows_number; $i++) : ?>

            <?php $s = lookup($symbol_array[$i]) ?>

            <?php if ($s->change > 0) $change_color = "color : green;" ;
                  else $change_color = "color : red;" ;?>
            <tr>
                <td> <?php echo $s->name; ?> </td>
                <td> <?= $shares_array[$i]; ?> </td>
                <td style ='<?php echo $change_color ;?>'> <?= $s->change ?> </td>
                <td> <?= $s->price ?> </td>
            </tr>

            <?php endfor ?>
        </table>
    </div>

    <div id="left">
        <h3 style ="font-weight : normal;"> Seja bem vindo(a) <span style="font-weight : bold;"> <?php echo $welcome_user?> </span>!</h3>
        <h4 style ="font-weight : normal; color : green;"> Você possui US$ <?php echo $cash;?>. </h4>
        <a href="quote.php"> Verificar preço das ações </a>
        <br>
        <br>
      <a href = "sell.php"> Vender ações </a>
        <br>
        <br>
        <a href = "buy.php"> Comprar ações </a>
        <br>
        <br>
        <a href = "history.php"> Histórico </a>
        <br>
        <br>
        <a href = "changepass.php" style = "fontsize : 15px"> Trocar senha </a>
        <br>
        <br>
      <a href="logout.php">log out</a>
    </div>

  </body>

</html>

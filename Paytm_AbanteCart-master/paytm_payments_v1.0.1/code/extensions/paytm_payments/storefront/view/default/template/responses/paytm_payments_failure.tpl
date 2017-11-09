<html>
  <head>
    <title>Paytm Payment Redirect</title>
    <META http-equiv="refresh" content="10;URL=<?php echo $continue?>">
  </head>
<body>
<h1 class="heading1">
  <span class="maintext"><i class="fa fa-thumbs-up"></i> <?php echo $text_response; ?></span>
  <span class="subtext"></span>
</h1>

<div class="container-fluid">

<section class="mb40">
	<div class="alert alert-success"><?php echo $text_failure; ?></div>
	<a class="btn btn-default " href="<?php echo $continue?>" ><i class="fa fa-arrow-right"></i> <?php echo $text_failure_wait; ?></a>
</section>
</div>
</body>
</html>

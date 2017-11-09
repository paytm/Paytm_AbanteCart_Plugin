<form action="<?php echo str_replace('&', '&amp;', $PAYTM_TXN_URL); ?>" method="post" id="checkout">

  <input name="MID"    type="hidden"  value="<?php echo $MID; ?>"   >
  <input name="ORDER_ID"     type="hidden"  value="<?php echo $ORDER_ID; ?>" >
  <input name="CUST_ID"   type="hidden"  value="<?php echo $CUST_ID; ?>"  >
  <input name="INDUSTRY_TYPE_ID" type="hidden"  value="<?php echo $INDUSTRY_TYPE_ID; ?>" >
  <input name="CHANNEL_ID"        type="hidden"  value="<?php echo $CHANNEL_ID; ?>"   >
  <input name="TXN_AMOUNT"           type="hidden"  value="<?php echo $TXN_AMOUNT; ?>"  >
  <input name="WEBSITE" type="hidden"  value="<?php echo $WEBSITE; ?>" >
  <?php if($CALLBACK_URL !=''){ ?> 
	<input name="CALLBACK_URL"      type="hidden"  value="<?php echo $CALLBACK_URL; ?>" >
  <?php } ?>
  <input name="CHECKSUMHASH"     type="hidden"  value="<?php echo $CHECKSUMHASH; ?>" >
  
	<div class="form-group action-buttons">
    	<div class="col-md-12">
	   	<button class="btn btn-orange pull-right" title="<?php echo $button_confirm; ?>" onclick="$('#checkout').submit();" type="submit">
	   	    <i class="fa fa-check"></i>
	   	    <?php echo $button_confirm; ?>
	   	</button>
	   	<a  href="<?php echo str_replace('&', '&amp;', $back); ?>" class="btn btn-default mr10" title="<?php echo $button_back; ?>">
	   	    <i class="fa fa-arrow-left"></i>
	   	    <?php echo $button_back; ?>
	   	</a>
	    </div>
	</div>
  
</form>
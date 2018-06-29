<style type="text/css">
	.borderRed{
		border-color: red;
	}
	.blueBtn, .blueBtn:hover{
		background-color: blue !important;
		border-color: blue !important;
	}
	.redBtn, .redBtn:hover{
		background-color: red !important;
		border-color: red !important;
	}
	.redColor{
		color: red !important;
	}
	.greenColor{
		color: green !important;
	}
</style>
<form action="<?php echo str_replace('&', '&amp;', $PAYTM_TXN_URL); ?>" method="post" id="checkout">
	<div class="hiddenFormPaytmFieldsDiv">
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
	</div>
  	<?php
  		if(isset($PAYTM_PROMOCODE_STATUS) && isset($PAYTM_promocode_LOCAL_VALIDATION) && isset($PAYTM_PROMOCODE_VALUE)){
  			if($PAYTM_PROMOCODE_STATUS=='enabled'){
  				if(($PAYTM_promocode_LOCAL_VALIDATION=='enabled' && trim($PAYTM_PROMOCODE_VALUE)!='') || $PAYTM_promocode_LOCAL_VALIDATION=='disabled'){
  	?>
	  	<div class="form-group">
	  		<div class="col-md-4">
	  		</div>
	  		<div class="col-md-8" style="margin-bottom: 5px;">
				<span class="input-group-btn">
	  				<input type="text" id="promoCode" class="form-control pull-left" placeholder="Paytm Promo Code" style="width: 70%;">
					<button id="" class="btn btn-primary pull-right btnPromoCode blueBtn" type="button">Apply</button>
				</span>
				<span class="messSpan"></span>
	  		</div>
	  	</div>
	<?php }}} ?>
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
<script type="text/javascript">
	// alert('test');
	$(document).ready(function(){
		$('.btnPromoCode').click(function(){
			$('.messSpan').html('');
			$('.messSpan').removeClass('greenColor');
			$('.messSpan').removeClass('redColor');
			if($.trim($("#promoCode").val())!=''){
				if($('.btnPromoCode').hasClass('redBtn')){
					$("#promoCode").val('');
				}
				$.ajax({
					url: 'index.php?rt=extension/paytm_payments/applyCode',
					type: 'post',
					dataType: 'json',
					data: $("form#checkout").serialize() + "&promoCode="+$("#promoCode").val(),
					success: function(res){
						// console.log('jqueryAjax res'.res);
						if(res.message.length > 0){
							if(res.message=='success'){
								$('.btnPromoCode').addClass('redBtn');
								$('.btnPromoCode').removeClass('blueBtn');
								$('.btnPromoCode').html('Remove');
								$("#promoCode").attr('disabled',true);
								$("#promoCode").prop('disabled',true);
								$('.messSpan').html('Applied Successfully');
								$('.messSpan').addClass('greenColor');
							}else if(res.message=='remove'){
								$('.btnPromoCode').removeClass('redBtn');
								$('.btnPromoCode').addClass('blueBtn');
								$('.btnPromoCode').html('Apply');
								$("#promoCode").attr('disabled',false);
								$("#promoCode").prop('disabled',false);
							}else{
								$('.messSpan').html('Incorrect Promo Code');
								$('.messSpan').addClass('redColor');
								$("#promoCode").addClass('borderRed');
							}
						}	
						if(res.hiddenFields.length > 0){
							$('.hiddenFormPaytmFieldsDiv').html(res.hiddenFields);		
						}
					}
				});
				$("#promoCode").removeClass('borderRed');
			}else{
				$("#promoCode").addClass('borderRed');
			}
		});
	});
</script>
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

            #paytm-pg-spinner {margin: 0% auto 0;width: 70px;text-align: center;z-index: 999999;position: relative;display: none}

            #paytm-pg-spinner > div {width: 10px;height: 10px;background-color: #012b71;border-radius: 100%;display: inline-block;-webkit-animation: sk-bouncedelay 1.4s infinite ease-in-out both;animation: sk-bouncedelay 1.4s infinite ease-in-out both;}

            #paytm-pg-spinner .bounce1 {-webkit-animation-delay: -0.64s;animation-delay: -0.64s;}

            #paytm-pg-spinner .bounce2 {-webkit-animation-delay: -0.48s;animation-delay: -0.48s;}
            #paytm-pg-spinner .bounce3 {-webkit-animation-delay: -0.32s;animation-delay: -0.32s;}

            #paytm-pg-spinner .bounce4 {-webkit-animation-delay: -0.16s;animation-delay: -0.16s;}
            #paytm-pg-spinner .bounce4, #paytm-pg-spinner .bounce5{background-color: #48baf5;} 
            @-webkit-keyframes sk-bouncedelay {0%, 80%, 100% { -webkit-transform: scale(0) }40% { -webkit-transform: scale(1.0) }}

            @keyframes sk-bouncedelay { 0%, 80%, 100% { -webkit-transform: scale(0);transform: scale(0); } 40% { 
                                            -webkit-transform: scale(1.0); transform: scale(1.0);}}
            .paytm-overlay{width: 100%;position: fixed;top: 0px;opacity: .4;height: 100%;background: #000;display: none;}
            #errorDivPaytm{color:red;}

</style>
 <script type="application/javascript" crossorigin="anonymous" src="<?php echo $PAYTM_ENVIRONMENT_DOMAIN; ?>merchantpgpui/checkoutjs/merchants/<?php echo $MID; ?>.js"></script>
<form action="#" method="post" id="checkout">
 
	<div class="form-group action-buttons">
    	<div class="col-md-12">
			<button class="btn btn-orange pull-right" title="<?php echo $button_confirm; ?>" id="checkoutJS" onClick="openJsCheckout();"  type="button">
				<i class="fa fa-check"></i>
				<?php echo $button_confirm; ?>
			</button>
			<a id="paytmback"  href="<?php echo str_replace('&', '&amp;', $back); ?>" class="btn btn-default mr10" title="<?php echo $button_back; ?>">
				<i class="fa fa-arrow-left"></i>
				<?php echo $button_back; ?>
			</a>
	    </div>
	</div>
  
</form>
<script type="text/javascript">
	
$(document).ready(function(){

$("#checkoutJS").click(function(){
    
var loader = '<div id="paytm-pg-spinner" class="paytm-pg-loader"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div><div class="bounce4"></div><div class="bounce5"></div></div><div class="paytm-overlay paytm-pg-loader"></div>';
	$("#maincontainer").append(loader);
    var txnToken = "<?php echo $TXN_TOKEN; ?>";
    if(txnToken){
	$('.paytm-pg-loader').css("display", "block");
	var config = {
                        "root": "",
                        "flow": "DEFAULT",
                        "data": {
                            "orderId": "<?php echo $ORDER_ID; ?>",
                            "token": "<?php echo $TXN_TOKEN; ?>",
                            "tokenType": "TXN_TOKEN",
                            "amount": "<?php echo $TXN_AMOUNT; ?>"
                        },
                        "merchant": {
                            "redirect": true
                        },
                        "handler": {
                           
                            "notifyMerchant": function (eventName, data) {
                                if(eventName == 'SESSION_EXPIRED' || eventName == 'APP_CLOSED'){
                                location.reload(); 
                               }
                            }
                        }
                    };
                    if (window.Paytm && window.Paytm.CheckoutJS) {
                        // initialze configuration using init method 
                        window.Paytm.CheckoutJS.init(config).then(function onSuccess() {
                            // after successfully updating configuration, invoke checkoutjs
                            window.Paytm.CheckoutJS.invoke();

                           // $('.paytm-pg-loader').css("display", "none");

                        }).catch(function onError(error) {
                            //console.log("error => ", error);
                        });
                    }


        }else{

         $("#paytmback").after("<div id='errorDivPaytm' ><?php echo $PAYTM_MSG; ?></div>");

        }


});




	});
</script>
# Paytm_AbanteCart
# Introduction

This is the readme file for Paytm Payment Gateway Plugin Integration for AbanteCart v1.2.x based e-Commerce Websites. 

The provided Package helps store merchants to redirect customers to the Paytm Payment Gateway when they choose PAYTM as their payment method. 

The aim of this document is to explain the procedure of installation and configuration of the Plugin on the merchant website.

# Installation
- Copy the "paytm_payments" folder directly to the extensions folder of your website i.e "website_root/extensions/".


# Configuration
- Log in to your Admin panel and locate the Paytm Wallet module in the Payment method section.
- Click on Install button to install it.
- Configure the required details like MID, Key, Website etc.

# Paytm PG URL Details
	staging	
		Transaction URL 		=> https://securegw-stage.paytm.in/theia/processTransaction
		Transaction Status Url 		=> https://securegw-stage.paytm.in/merchant-status/getTxnStatus

	Production
		Transaction URL 		=> https://securegw.paytm.in/theia/processTransaction
		Transaction Status Url 		=> https://securegw.paytm.in/merchant-status/getTxnStatus

See Video : https://www.youtube.com/watch?v=Dz1nYrd-5e4
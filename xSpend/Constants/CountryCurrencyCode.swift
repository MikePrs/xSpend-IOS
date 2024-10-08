//
//  CountryCurrencyCode.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 19/7/23.
//

import SwiftUI


struct CountryCurrencyCode {
    var currencies: [String] {
        return Array(Set(countryCurrency.values))
    }
    
    
    var countryCurrency:[String:String] = [
        "New Zealand":"NZD",
        "Cook Islands":"NZD",
        "Niue":"NZD",
        "Pitcairn":"NZD",
        "Tokelau":"NZD",
        "Australian":"AUD",
        "Christmas Island":"AUD",
        "Cocos (Keeling) Islands":"AUD",
        "Heard and Mc Donald Islands":"AUD",
        "Kiribati":"AUD",
        "Nauru":"AUD",
        "Norfolk Island":"AUD",
        "Tuvalu":"AUD",
        "American Samoa":"EUR",
        "Andorra":"EUR",
        "Austria":"EUR",
        "Belgium":"EUR",
        "Finland":"EUR",
        "France":"EUR",
        "French Guiana":"EUR",
        "French Southern Territories":"EUR",
        "Germany":"EUR",
        "Greece":"EUR",
        "Guadeloupe":"EUR",
        "Ireland":"EUR",
        "Italy":"EUR",
        "Luxembourg":"EUR",
        "Martinique":"EUR",
        "Mayotte":"EUR",
        "Monaco":"EUR",
        "Netherlands":"EUR",
        "Portugal":"EUR",
        "Reunion":"EUR",
        "Samoa":"EUR",
        "San Marino":"EUR",
        "Slovenia":"EUR",
        "Spain":"EUR",
        "Vatican City State (Holy See)":"EUR",
        "South Georgia and the South Sandwich Islands":"GBP",
        "United Kingdom":"GBP",
        "Jersey":"GBP",
        "British Indian Ocean Territory":"USD",
        "Guam":"USD",
        "Marshall Islands":"USD",
        "Micronesia Federated States of":"USD",
        "Northern Mariana Islands":"USD",
        "Palau":"USD",
        "Puerto Rico":"USD",
        "Turks and Caicos Islands":"USD",
        "United States":"USD",
        "United States Minor Outlying Islands":"USD",
        "Virgin Islands (British)":"USD",
        "Virgin Islands (US)":"USD",
        "Hong Kong":"HKD",
        "Canada":"CAD",
        "Japan":"JPY",
        "Afghanistan":"AFN",
        //        "Albania":"ALL",
        //        "Algeria":"DZD",
        //        "Anguilla":"XCD",
        //        "Antigua and Barbuda":"XCD",
        //        "Dominica":"XCD",
        //        "Grenada":"XCD",
        //        "Montserrat":"XCD",
        //        "Saint Kitts":"XCD",
        //        "Saint Lucia":"XCD",
        //        "Saint Vincent Grenadines":"XCD",
        //        "Argentina":"ARS",
        //        "Armenia":"AMD",
        //        "Aruba":"ANG",
        //        "Netherlands Antilles":"ANG",
        //        "Azerbaijan":"AZN",
        //        "Bahamas":"BSD",
        //        "Bahrain":"BHD",
        //        "Bangladesh":"BDT",
        //        "Barbados":"BBD",
        //        "Belarus":"BYR",
        //        "Belize":"BZD",
        //        "Benin":"XOF",
        //        "Burkina Faso":"XOF",
        //        "Guinea-Bissau":"XOF",
        //        "Ivory Coast":"XOF",
        //        "Mali":"XOF",
        //        "Niger":"XOF",
        //        "Senegal":"XOF",
        //        "Togo":"XOF",
        //        "Bermuda":"BMD",
        "Bhutan":"INR",
        "India":"INR",
        //        "Bolivia":"BOB",
        //        "Botswana":"BWP",
        "Bouvet Island":"NOK",
        "Norway":"NOK",
        "Svalbard and Jan Mayen Islands":"NOK",
        "Brazil":"BRL",
        //        "Brunei Darussalam":"BND",
        "Bulgaria":"BGN",
        //        "Burundi":"BIF",
        //        "Cambodia":"KHR",
        //        "Cameroon":"XAF",
        //        "Central African Republic":"XAF",
        //        "Chad":"XAF",
        //        "Congo Republic of the Democratic":"XAF",
        //        "Equatorial Guinea":"XAF",
        //        "Gabon":"XAF",
        //        "Cape Verde":"CVE",
        //        "Cayman Islands":"KYD",
        //        "Chile":"CLP",
        "China":"CNY",
        //        "Colombia":"COP",
        //        "Comoros":"KMF",
        //        "Congo-Brazzaville":"CDF",
        //        "Costa Rica":"CRC",
        "Croatia (Hrvatska)":"HRK",
        //        "Cuba":"CUP",
        "Cyprus":"EUR",
        "Czech Republic":"CZK",
        "Denmark":"DKK",
        "Faroe Islands":"DKK",
        "Greenland":"DKK",
        //        "Djibouti":"DJF",
        //        "Dominican Republic":"DOP",
        "East Timor":"IDR",
        "Indonesia":"IDR",
        //        "Ecuador":"ECS",
        //        "Egypt":"EGP",
        //        "El Salvador":"SVC",
        //        "Eritrea":"ETB",
        //        "Ethiopia":"ETB",
        //        "Estonia":"EEK",
        //        "Falkland Islands (Malvinas)":"FKP",
        //        "Fiji":"FJD",
        //        "French Polynesia":"XPF",
        //        "New Caledonia":"XPF",
        //        "Wallis and Futuna Islands":"XPF",
        //        "Gambia":"GMD",
        //        "Georgia":"GEL",
        //        "Gibraltar":"GIP",
        //        "Guatemala":"GTQ",
        //        "Guinea":"GNF",
        //        "Guyana":"GYD",
        //        "Haiti":"HTG",
        //        "Honduras":"HNL",
        "Hungary":"HUF",
        "Iceland":"ISK",
        //        "Iran (Islamic Republic of)":"IRR",
        "Iraq":"IQD",
        "Israel":"ILS",
        //        "Jamaica":"JMD",
        //        "Jordan":"JOD",
        //        "Kazakhstan":"KZT",
        //        "Kenya":"KES",
        //        "Korea North":"KPW",
        //        "Korea South":"KRW",
        //        "Kuwait":"KWD",
        //        "Kyrgyzstan":"KGS",
        //        "Lao PeopleÕs Democratic Republic":"LAK",
        //        "Latvia":"LVL",
        //        "Lebanon":"LBP",
        //        "Lesotho":"LSL",
        //        "Liberia":"LRD",
        //        "Libyan Arab Jamahiriya":"LYD",
        "Liechtenstein":"CHF",
        "Switzerland":"CHF",
        //        "Lithuania":"LTL",
        //        "Macau":"MOP",
        //        "Macedonia":"MKD",
        //        "Madagascar":"MGA",
        //        "Malawi":"MWK",
        "Malaysia":"MYR",
        //        "Maldives":"MVR",
        //        "Malta":"MTL",
        //        "Mauritania":"MRO",
        //        "Mauritius":"MUR",
        "Mexico":"MXN",
        //        "Moldova Republic of":"MDL",
        //        "Mongolia":"MNT",
        //        "Morocco":"MAD",
        //        "Western Sahara":"MAD",
        //        "Mozambique":"MZN",
        //        "Myanmar":"MMK",
        //        "Namibia":"NAD",
        //        "Nepal":"NPR",
        //        "Nicaragua":"NIO",
        //        "Nigeria":"NGN",
        //        "Oman":"OMR",
        //        "Pakistan":"PKR",
        //        "Panama":"PAB",
        //        "Papua New Guinea":"PGK",
        //        "Paraguay":"PYG",
        //        "Peru":"PEN",
        "Philippines":"PHP",
        //        "Poland":"PLN",
        //        "Qatar":"QAR",
        "Romania":"RON",
        "Russian Federation":"RUB",
        //        "Rwanda":"RWF",
        //        "Sao Tome and Principe":"STD",
        //        "Saudi Arabia":"SAR",
        //        "Seychelles":"SCR",
        //        "Sierra Leone":"SLL",
        "Singapore":"SGD",
        //        "Slovakia (Slovak Republic)":"SKK",
        //        "Solomon Islands":"SBD",
        //        "Somalia":"SOS",
        "South Africa":"ZAR",
        //        "Sri Lanka":"LKR",
        //        "Sudan":"SDG",
        //        "Suriname":"SRD",
        //        "Swaziland":"SZL",
        "Sweden":"SEK",
        //        "Syrian Arab Republic":"SYP",
        //        "Taiwan":"TWD",
        //        "Tajikistan":"TJS",
        //        "Tanzania":"TZS",
        "Thailand":"THB",
        //        "Tonga":"TOP",
        //        "Trinidad and Tobago":"TTD",
        //        "Tunisia":"TND",
        "Turkey":"TRY",
        //        "Turkmenistan":"TMT",
        //        "Uganda":"UGX",
        //        "Ukraine":"UAH",
        //        "United Arab Emirates":"AED",
        //        "Uruguay":"UYU",
        //        "Uzbekistan":"UZS",
        //        "Vanuatu":"VUV",
        //        "Venezuela":"VEF",
        //        "Vietnam":"VND",
        //        "Yemen":"YER",
        //        "Zambia":"ZMK",
        //        "Zimbabwe":"ZWD",
        "Aland Islands":"EUR",
        //        "Angola":"AOA",
        //        "Antarctica":"AQD",
        //        "Bosnia and Herzegovina":"BAM",
        //        "Congo (Kinshasa)":"CDF",
        //        "Ghana":"GHS",
        //        "Guernsey":"GGP",
        "Isle of Man":"GBP",
        //        "Laos":"LAK",
        //        "Macao S.A.R.":"MOP",
        "Montenegro":"EUR",
        //        "Palestinian Territory":"JOD",
        "Saint Barthelemy":"EUR",
        "Saint Helena":"GBP",
        //        "Saint Martin (French part)":"ANG",
        "Saint Pierre and Miquelon":"EUR",
        //        "Serbia":"RSD",
        "US Armed Forces":"USD"
    ]
}

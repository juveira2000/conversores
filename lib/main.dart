import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var controllerString = TextEditingController();
  var controllerB64 = TextEditingController();
  var controllerByte = TextEditingController();

  var base64String = 'VGVzdGUgZGUgQ29udmVyc2FvIEZsdXR0ZXI=';
  var pdfB64 =
      'JVBERi0xLjUKJcOkw7zDtsOfCjIgMCBvYmoKPDwvTGVuZ3RoIDMgMCBSL0ZpbHRlci9GbGF0ZURlY29kZT4+CnN0cmVhbQp4nE2MuwoCMRBF+3zF1MLGmWwmmUAYcH0UdgsBC7FztRPcxt93kwWRgQuHe+6gJfiYNyCgRSfAia2LDOLJSiCYJ3PZwGs1lpufZiiGgxWIsbdJEpQ7bE8E5KA8rhlJXUZXo9eOftyFjB4Zg3buX/JKsTJJxtg6j6KLnBrs2g+PQ6OoXGGt9i0PylL3t3I2x2JGM8IXlbss+AplbmRzdHJlYW0KZW5kb2JqCgozIDAgb2JqCjE1MgplbmRvYmoKCjUgMCBvYmoKPDwvTGVuZ3RoIDYgMCBSL0ZpbHRlci9GbGF0ZURlY29kZS9MZW5ndGgxIDEwMzQ4Pj4Kc3RyZWFtCnic5TltdBvVle/OjGTJlq0Py44VJdYoihMHf8iJY4hJjBV/yE5ssBPbIAUSS5ZkS8SWhCQ7BBZilgZSp2nCV/go22Q5lKU0XcYksKabEtOW9tDSDeyS7vKR4nMK7fYsKV42cFiC5b3vzcixQ6Cne/bfjvze3O973733vRnJqcRwiOjIKOGJKzDkjzsthSZCyGuEgCkwkhLrOgrWIzxFCPfP/fGBocf+4abzhAgnCMk6MTC4u/+9O5c/SYgujEMTDvmDd/bfsYaQojjauDKMhO707izEn0Z8eXgodesvs/5QjzjaJ+sGYwH/22Yz+rMIiBcP+W+NrxCaOMSXIy5G/UOh4nquFfEmQnJG4rFkKkiWz6Kpk5QfT4Ti7Y/1vYL4u4Twh5AG+KGXDkE1xTleUKmzNNrsHF0u+X94qQ6QAtKqqiN6Emfzgos/RizkUUJmP6TYxTndPvv5/2UUGvn2CHmKnCAHyFtku8Jwk04SIcNImX+9TN5AKr06yTbyDBn7CrPHyATyZTkfOUhXctmrkzxMjpNfLPDSSYbI7RjL8+QtWE1exVaJkY9BQ+4ir6DVj5F27eVMcXk49TOwfx71HfIdbj/ZzL2PyKOUwzk5A/kZeRx2oOUUrvPA3Io3fMnoveQOnLtImIwgzC5V3RdvE+3sf+Gq7iCbyV+TjWRwnsZJOMJnY/26yRHM6cuM5swws1r5m7kXOG7mAUTuIwM4/IBr5w7wG78iQ3/xxfeQXFjFlxDt5bjcWqJPf86tmT3PLyfZpGd2OkObbZv9L96fjgq9whJVnfCrr/Ohvk8YQm0y+0H69nRQdZ3qKawWniSulhu3eT093V1bt3R2XHdte9vmTa0t7uamxoaNrvpr6jasv7p23VVX1qyuclZWlJeuXFGy3LHMbisyGw36vNycbK0mS60SeA5IuSiBr1niS0Sj2+9odvhbK8rF5qJwU0V5s8Ptk0S/KOFNWOFobWUkh18SfaK0Am/+eWSf5ELJ/kskXbKka04SDOIGsoG6cIjSr5sc4gRs2+JB+ECTwytK5xh8LYOFFQzJRcRuRw0WFY1WbJbcI+GxZh/GCOM52Y2OxlB2RTkZz85BMAchqdQRH4fSa4ABXGnz1eMc0eRSt7jSZn9Q6tziaW6y2u3eivJNUp6jibFIIzMpqRulLGZSjNDQyX5xvHxy7FsTBtLnK9MFHUH/TR6J96PuGN88NnavZCyTVjmapFW3vV+EKw9J5Y6mZqmMWm3bOuen7aJLkFQlBoc49gnB5TjOfbiQ4lco6hLDJ4SCEtcowVaPnV5WN+Z6bMztEN1jvjH/xOxon0M0OMbGdbqxeDOmm3R60MTE7I/2WyX3t7ySwReGq73K0t1b26T8LTd6JK7ELYb9SMG/eod9ndVunJPp/Co2wbRgcjDDdjtNw/4JF+lDRBrd4pFxkfRZnyMuZ5lX4nyUM5nhFPRQzmiGM6fuc2Bt27o8Y5JQsinoaMaM7/dLo33YXTfTwjgMUt6nVrtjzGQUa51eJitiVJuCEVFSrcAkodZ8BewbqjJmYEjep/LtnBUdrDCaxFoHmqF2mh3NPuVvJFyEBkRMdGuZ3AjdHsnVhIDLr1SsebzKiRp+HxYs0sSKKTkdccnsaJirLg2rOdLlYSqKmmRulIgvoGhJzma2r8TmMV+THAK15djieZFUz06NrxWtx6vJWuJtosKFjdhlK5rHPMF+yeazBnHf9Yseq11yebHCXocn5KVthxlaNWVlzeFlvdLtaetytG3Z5lmnBCIzqDmhpPkSMw6PVTaDDShpSjSih7PyXhQ0IEF0I+Bo2ICzlFWiwWHAhDMqbdyGDaIHrCQjjWFIq8TmUJMiR/EFRlW0nRpbM9bUFEU7ja1Wu9cuXxXlHLJFxTFqaGhSWzMsPKaQocH+bGxlJJrLItr0oscRcngdYVFydXro2mh6WJaVZLCcK7XqXoDNSxamidiRnUFoMiV3mXV+cqUWhs+hrZewN2XY4pjG0dY1Ro07FIMEI98kEdrCrnVGKzsL6IZ24NkrGnBLsw09Nu5y0c0cvpoacWwKjjm6PBuYNJ4nd1hvo75MpA3auhsqyvFoaxh3wL4t4y7Y17XN86IB3wv3dXue44Br9DV4x5cjz/OiiA8NRuUolRIpIlKEWtqKiIbJW190ETLKuAIjMDwwAYTRNBkakMAEJ9MMsqMVzJGLcMgRZI4rIy0gTSPTRhmNXeOEpsyVrXJpXFqXjsvlrONASc8h5Uf4HqsFclwHuWAdR62tjDwBo+Nal1WWGEUJlxzhvp6Lrnu2eY7r8OlsZTM6aqAXtktRGIuNj5VmMUgb5a+84TGfl242UoilwT+QwHENlslxDQai1knZjlCDlONooPR6Sq+X6WpKz8IWhUJA9VGsfacEtANu9NhxS4qLX7WOGc7RSnnxUBkzfFCBGSvB7w0v4zuoGTa4zpq4HE7DFxTqiAa0vEajNfJa3ufV8iaOcL1eYqovBH0hTBXCqUI4WAh7CqG3EJAoMvrO6UI4XQhHGS9eCB2FYGMMmS4VwhHGijE1VyFUMQFSCO8x7iijVzHK+lnmR1Y7yBgdjDfN6FLGh6wgMp1pZmiSuRllXAzNmfGxfe66JXMllGvHJfQvcSiP1JcZSXURm43VRc7eHdurjSZYVGusXl1lr7nK6FimB4fRbnSsrIQyMC4qgPVnqme2WxuFx5usxb+8dfWZGqvwsPkNWJ9+5Y2snAs7rTX0hQoIfpcT7sAaWEnU5daZzWBR60FYslSX7/P26mI6rkIHPNEZdJxWpdMJVqvZ57VCr9dqEnJ8XgErI/BTS+HoUogvhc6l4FoqLxYjLiMYcJnRRGpZwL3bt5cpMdOo68G4soYGvALjtV9VjZDdaBfroZq3rz92jP9Tgxh/8x242eZy2dKHQQNcZ21D/oU3cB3fXVyTPvVW3sz5o+ngEzNnDZ+lv8vW8s3ZD/nzqnZSQbyutYs0K4uJcaXRWVmsMV9xharXC1fkm6293iKzMO2EKSe87oRJJ0yzucoJopNFTtNP6qtp8NUs+FoMGqdqjBrDzq9eVAzVa66sWVuprll7ZfWaRXQJjmXqAnMxDrVj2YqV+zc6Sp73fOtv6gJ37r0zUDd95omXNjr6D9/zcF1gz949gbo/TQ2+3QOR552tB+9s3bGxonLd9Xu2H32hLP3HJzcP+TZeX1fuXH/j3b6fnFlhpy/WZP3s58LHWCMNMZEV5KzrAe0yskSVl1dQYFuyTChdWWLweUtMNpVOpfN59SrI4VWqovyiQlyr4PMW8fkFvd5809FSOFQKo6UQLwVfKbhKYaoUjjAKop2MIpbCe6UwyShVDCWlcPVpxjaUwjQzQZjm66VwlNmSNee6+EstLTcz9sPCdpCh+ostIbcFrKX9gAnOZ0AhQirsb2wVsRDTm1UMBWbBXsK/9NgPT7/zxKOhk6enxx7/wTNfFB07xoXwq+p9dz//8/QnsyTdzX92ezytGk0XHrh75jX1fR/IjfPwkyNPLcn/4b6Xf8F+DSCL8JvVA/QMIjFXM8nKQif6XE22ptebRfJ4wZjNg1pQY5ebcBvXd7KjozOz6afYgSNv987MqbJ9Xip2bM/s3GrToloKVdN9y7Yt3aV06wKurSBLK99495mZh86kVz3MXXUC7oLoM3DiAc6QdllraqzwI+79xTU1i2ce4nbSO/1aRbpnP1QlsedzSCG50lVMdGqjzrioyMz3es35edpeb55AiqDeVQRiEdxyCwuIyGmvVXYiGEzVa0xGA+dYxvEGu0iMBoIzlPzb7z94+63f/+Ff3+AOQhO0p6X0ZPrltMQdTf84/VtYBo2wEazpD9KnuGPp76WfTT+TfgK2Y0z0TLGzfi0ik65RUqDKztYX6BdbtGo80LW5JhMe7CZDr9fEZ+tz9b3eXNPBxbBnMcQWg3Mx6BfDe4vh1GI4wigdi6Ge0WcZ/TQj9jKxdbLcKaYsaz7L1PYwHRujaOa142V7c+5wVZrzYm4WNKRKqRdtRSNudH7bYy/0hb//t+nrzsz86sgx+Bw+/O8/8tL3vj2z97Hz6QZaMXZSDf/Tb2hOZr9QDWNOtNhx7S6nykxyzblFlkW4NRfhJl3EG8y9XkOWz2swEQvWywKiBaYscNQCcQuwc2nH/EN1XvWI3UH3iQnkypU4WJDCk+k30n84cev3Pv3jzGeQhP7036W/n152DPfJ02CBZRdu18Ay/pX08+kTWNinBDnauWfCKox1ETnveqrQZDIbAdRqcw5vKTISfCwYY0auwoiPBaPBiI8Fo1Gt1eIRpM3qxcd1ZrucsMCTFnjQAqMWSFkgaAHBAtMWeN8CbzI6En0W6LZAkwVet8DPLDCn8o2MCnIxE1UsGWZmofY8MyHLIT5pAU6ywC29tyx8Zi58qiYSl630pU8lJaMXC73g8QRPvzfz8pG5J9N+W12djds28+lcpekz6Q36TJJzqHoEc5hPbnBV5WepTVptnjqvwKwieiN2vIbD15s8XR4ezFk6EynAiheAWABTBXC0ADLVrq5WDg92r57XlzRMdmAYHfPCBeHuE/DqMf8Xr5xIX3XsGBzmnhP+RI+KCybhhQuPZQL9wsZ+ksEzj6gmVK1ET0zQ6/rYmKfXC6Zcg06XlWUQ+Hxzbp4xDzeq0QgGtUrQZQl6wNCzwXTeDO+b4U0z/MwMJ8zwpBkeNMM3zJAyQ9AM3WZoMsNaMyw3A75QCGb4S+Vrv0ZhvrTAZCbN2AJmOGqGQ2YYNUPcDJ1mcJmhygyiGQxmmGJClwh0mOHSNrkF22ju9StxuYZa8KLGLvquwM51WiZTrRPfHCoz72ZGE6tXbe3qqhJaI6gGVivezgNvh1+nWx6BV1+Cd56ZefXE3pnpe2H/7+FfamiVPrugYUf+3ek7hPDMsFwv2lNd2FMFpBjf1q4pMBisuVbcmoW5ZqPJmKsWbKIBX+TwBc2qFbSWzI40ylvSLJgMIrwuQlwEl0jXnsjEPv/sI9ULtgMu4ZI9sYY9h+lCtHNnIzz9q5kzR45xjV9M338X7LwvfSp9L2Q/9I8/GD/+MNeeFjKd98zJe366YubfrTVcO9zx6F0zP91L2O/zHCHP/f3xfb36DZ9wNvm34dceWNp68Zc/fMpN4FNu7odjdk6RLHu6mdwwn7LgylPX4kn2O1KCY72QJN9EN0R1PVmv+gVZhKMbaRRen7njMFM+0/4JlMKD8CDXwD3BfciP8K8JUWFS9YhaUDzlkUp8N5MrYyBOchMCP+V/jjTKLYboXDzXz8UGKHm9AnMki/QrMI9lG1JgAWX2KbAKvTyiwGrcp08pcBa5jTyvwBr8/uRUYC3Jg0YFzoYobFHgHLKEOzX3n5BK7h0FziU1vFaB88hi/hoavUB/wT3GexQYiCgICsyRPGG5AvPkSmGNAgsoE1ZgFVki7FNgNSkWnlTgLHJe+IkCa0ip6gUF1uK77G8VOJt7V/W5AueQdZrfKLCO3KTNU+BccrP2ZgXOI2u1bzZFBiKpyG2hoBj0p/xiIBbfnYgMhFNiaWCVuKZqdZXYEosNDIbExlgiHkv4U5FYtDK78VKxNeJWNNHqT5WLm6KByvZIX0iWFbtCiUj/1tDA8KA/sTEZCEWDoYRYIV4qcSl+fSiRpMiayqqqytUXuZcKR5KiX0wl/MHQkD+xU4z1LwxETIQGIslUKIHESFTsqeyqFDv9qVA0JfqjQbF7TrGjvz8SCDFiIJRI+VE4lgpjqDcPJyLJYCRAvSUr51YwLx1dqdBISLzWn0qFkrFogz+JvjCy7kg0liwXd4UjgbC4y58Ug6FkZCCKzL7d4kIdEbl+XEs0GhtBkyOhcoy7PxFKhiPRATFJl6xoi6mwP0UXPRRKJSIB/+DgbqzZUBy1+rBIuyKpMDoeCiXF60K7xK2xIX/0mUo5FMxNPyZVjAzFE7ERFmNFMpAIhaLozB/090UGIym0FvYn/AHMGKYtEkiyjGAixLg/WtE8nIjFQxjpDS3tFwUxQDmbydjgCHqm0tFQKEg9YtgjoUFUQseDsdhOup7+WAIDDabCFfMi749FU6gaE/3BIC4csxULDA/ROmGaU5ng/IFEDHnxQX8KrQwlK8OpVPxqp3PXrl2VfqU0AaxMJVp2fh0vtTseUuqRoFaGBtux/FFaumFWX7qIrk3tYkcc8+PG4ERFoFzMtObqytWKC0xjJJ5KViYjg5WxxICzw91OmkiEDOBI4biNhEiQiDj8iPsRCpAYiZPdJMGkwkgVSSlSV+F9Dakiq3GIpAWlYsgfRH2RNCKcQC06+5ndGIniOZrNOF9vbQ1CW5UoWpl2OUKbUD+AFtpRrw+58+2KpItRInjOUs0BMoxx+JGykSRRK4QyQSYhkgocf87Gn+Nfz6DkHGcNxlWFn0qM/nK6f85yBG2JLNcpxqGxDrH4dyIthnpflxER5UKsfknkhBgWZFap7R6U6GJSnUyT5iLFvEWZVPdlPHagx37UD7BaZiQDzDbtCdlyDOGwktWbMeMJFkGQ6WXWlkTPX67B5buji0U3wnxey+gUTzJeA+JJZV1yzrpZFDGk0lzswkio3zCD/SyfQaZNuyyqaPZh34lf60dUdP1KXaLMx4gSJdUpV/Ldz+Yk8xtFHyKLT67yQt8iy5OfZV2u9BByU0w2gPRB/OxW9tkQZkX21afspF1sX4aVFQ8xuyK5Du+7WFfEWN2i9mWsxhezIvdNv9KpItONIxxjq8jksYLVhq4kxCKlkJ/t/T7UGGS+5djCrDv8rLYhpdYptoJMvoLKSmnUcUapIM2sL+iODyk5vQFPivbLWpQzOL83aU0GWbzJebajLNrg3BrlbFOpQcWTvOJBdiLtnKtPP+s3OaNBZq3iK3Lez3KTUrzGWERB/MgVl3srhrrDrB7yfpK7OfWlzPlZfmOKXpydSyklliG2P8KsA+Pkany3dGJ09FPJ+nD+rgkoe6ZSidn5v9ajccVZBufvj8RcLEMYY7uy+6Nzu2543v7NVKILz6B2dl7Elf5xK5kTL7FAd82lp+Zqdl4uXIXcjRHEUyyeJMtlJVvDAPI70EM7e4+Wvy3YMabLXOPazo19ECIAYRjAr+Y28JHroJf0wEZSBy68u5DXgPdGxOm9EurIKMrVIf0axDcgfT0enjac63F04DiIQ8AhS1ShhBPvTgWvQLwcNU7jDGxQaj1S6X0z4q14b1HubqQ3471ZwTchjnfigyx8Ea9n8ykQXMdhagZOz4A4A3suQOcFGP340Mfcf06vsj07fWqa6/io96NnP+KrPgL9R6Ah5wznOs/5zsXPHT2nztZ/CDryH2D83dQ623t1Z3t+W/duDzmLKztbdbbz7OhZ6azqLPA97/KFNsOkOFk1GZ8cnXx9cmpyelIz+tKhl7gfn3Ta9CdtJznb8Y7je47zvqdB/7Ttaa7zO77vcIceB/3jtsedj/OPPVppe7Sl2Pbw4ZW2qcPTh7mJ2cnjh3ON7pPQAe2kDnN43XF+1vbsxgK4Fpelx9mGw4mjA0cMx0Ec+L0HxW04nNDuWsf3PgQ591vvL7v/9vv336+K3zN6z6F7+NG9h/Zyz46cGuGSnatssWiZLdpyhc1SXdSTVc33qNENendt6ispdft6XbZeFLpxW5VtW8sqW361qUeFCxZQUM/b+Hq+g4/xB/lTfJZma2exbQuOqc7pTs7VqdW59R22DmcHPzE75Qq12dHa5vjm0c38JvcqW2vLOpu+xdbibDnd8l7LRy3q3hY4gn/uZ92n3LzLvcrpdrmL7e4lrdaewuqCHiPoewzV+h4OsNDVpMepn9Vzen2vfo+e15N6wo0Wggom4NB4d1dZWdtE1uzWNknTeaME+6SSLjq7tmyT1Psk0rPtRs84wLe9ew8cIA1L26Q1XR7Jt9TbJgURcFFgFAHD0vFC0uBNJlNl7IKyMoSHcSZlw2VI3JGUqWSOT8qSkMQzKsmUoIwKyDjgXEZ5SKB6gNo7koROlFkmK1HtpGKOKcsTA4p2/A+mljPaCmVuZHN0cmVhbQplbmRvYmoKCjYgMCBvYmoKNTk5OQplbmRvYmoKCjcgMCBvYmoKPDwvVHlwZS9Gb250RGVzY3JpcHRvci9Gb250TmFtZS9CQUFBQUErTGliZXJhdGlvblNlcmlmCi9GbGFncyA2Ci9Gb250QkJveFstNTQzIC0zMDMgMTI3OCA5ODJdL0l0YWxpY0FuZ2xlIDAKL0FzY2VudCA4OTEKL0Rlc2NlbnQgLTIxNgovQ2FwSGVpZ2h0IDk4MQovU3RlbVYgODAKL0ZvbnRGaWxlMiA1IDAgUgo+PgplbmRvYmoKCjggMCBvYmoKPDwvTGVuZ3RoIDI4My9GaWx0ZXIvRmxhdGVEZWNvZGU+PgpzdHJlYW0KeJxdkctugzAQRff+Ci/TRYR5JG0khJSSIrHoQyX9ALAHaqnYljEL/r4eO22lLkBnZu61xtdJ3V5aJV3yZjXvwNFRKmFh0avlQAeYpCJpRoXk7laFP597QxLv7bbFwdyqUZclSd79bHF2o7uz0APckeTVCrBSTXT3UXe+7lZjvmAG5SgjVUUFjP6c59689DMkwbVvhR9Lt+295U9w3QzQLNRpXIVrAYvpOdheTUBKxipaNk1FQIl/szSPlmHkn7310tRLGTsUlecscHFAzmM/Ry4CZwz5EDUZ8jFqTsj3sd8gP8R+0J9iP5x/jnxEfoz8hFxHTpEv0ZuF5W9b4jUw5594KF+t9dGExwiZYBpSwe97GW3QFb5vxrCJigplbmRzdHJlYW0KZW5kb2JqCgo5IDAgb2JqCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1RydWVUeXBlL0Jhc2VGb250L0JBQUFBQStMaWJlcmF0aW9uU2VyaWYKL0ZpcnN0Q2hhciAwCi9MYXN0Q2hhciAxMwovV2lkdGhzWzc3NyA2MTAgNjEwIDU1NiAyNTAgNjY2IDcyMiA3MjIgNTU2IDcyMiA1NTYgNzIyIDcyMiA2NjYgXQovRm9udERlc2NyaXB0b3IgNyAwIFIKL1RvVW5pY29kZSA4IDAgUgo+PgplbmRvYmoKCjEwIDAgb2JqCjw8L0YxIDkgMCBSCj4+CmVuZG9iagoKMTEgMCBvYmoKPDwvRm9udCAxMCAwIFIKL1Byb2NTZXRbL1BERi9UZXh0XQo+PgplbmRvYmoKCjEgMCBvYmoKPDwvVHlwZS9QYWdlL1BhcmVudCA0IDAgUi9SZXNvdXJjZXMgMTEgMCBSL01lZGlhQm94WzAgMCA1OTUuMzAzOTM3MDA3ODc0IDg0MS44ODk3NjM3Nzk1MjhdL0dyb3VwPDwvUy9UcmFuc3BhcmVuY3kvQ1MvRGV2aWNlUkdCL0kgdHJ1ZT4+L0NvbnRlbnRzIDIgMCBSPj4KZW5kb2JqCgo0IDAgb2JqCjw8L1R5cGUvUGFnZXMKL1Jlc291cmNlcyAxMSAwIFIKL01lZGlhQm94WyAwIDAgNTk1IDg0MSBdCi9LaWRzWyAxIDAgUiBdCi9Db3VudCAxPj4KZW5kb2JqCgoxMiAwIG9iago8PC9UeXBlL0NhdGFsb2cvUGFnZXMgNCAwIFIKL09wZW5BY3Rpb25bMSAwIFIgL1hZWiBudWxsIG51bGwgMF0KL0xhbmcocHQtQlIpCj4+CmVuZG9iagoKMTMgMCBvYmoKPDwvQ3JlYXRvcjxGRUZGMDA1NzAwNzIwMDY5MDA3NDAwNjUwMDcyPgovUHJvZHVjZXI8RkVGRjAwNEMwMDY5MDA2MjAwNzIwMDY1MDA0RjAwNjYwMDY2MDA2OTAwNjMwMDY1MDAyMDAwMzYwMDJFMDAzMT4KL0NyZWF0aW9uRGF0ZShEOjIwMjExMjAxMTIyOTMyLTA0JzAwJyk+PgplbmRvYmoKCnhyZWYKMCAxNAowMDAwMDAwMDAwIDY1NTM1IGYgCjAwMDAwMDcyMTMgMDAwMDAgbiAKMDAwMDAwMDAxOSAwMDAwMCBuIAowMDAwMDAwMjQyIDAwMDAwIG4gCjAwMDAwMDczODIgMDAwMDAgbiAKMDAwMDAwMDI2MiAwMDAwMCBuIAowMDAwMDA2MzQ2IDAwMDAwIG4gCjAwMDAwMDYzNjcgMDAwMDAgbiAKMDAwMDAwNjU2MiAwMDAwMCBuIAowMDAwMDA2OTE0IDAwMDAwIG4gCjAwMDAwMDcxMjYgMDAwMDAgbiAKMDAwMDAwNzE1OCAwMDAwMCBuIAowMDAwMDA3NDgxIDAwMDAwIG4gCjAwMDAwMDc1NzggMDAwMDAgbiAKdHJhaWxlcgo8PC9TaXplIDE0L1Jvb3QgMTIgMCBSCi9JbmZvIDEzIDAgUgovSUQgWyA8MUY0MjFFOTQ2MzdEMjEwRDQyRDlGQkYzOTBEMEE1QTM+CjwxRjQyMUU5NDYzN0QyMTBENDJEOUZCRjM5MEQwQTVBMz4gXQovRG9jQ2hlY2tzdW0gLzExMjE3QUNEQTdDMzI4M0YyNkM5QTBBRkNFQjIyQTI3Cj4+CnN0YXJ0eHJlZgo3NzUzCiUlRU9GCg==';

  @override
  void initState() {
    controllerB64.text = base64String;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversor B64 e Uint8List"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                'Valor em Base 64',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                readOnly: true,
                controller: controllerB64,
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(
                'Valor em String',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                readOnly: true,
                controller: controllerString,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(
                'Valor em Byte',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                readOnly: true,
                controller: controllerByte,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            ElevatedButton(
              onPressed: conversor,
              child: const Text("Converter"),
            ),
            ElevatedButton(
              onPressed: toPdf,
              child: const Text("Gerar PDF"),
            ),
          ],
        ),
      ),
    );
  }

  //Converte de Base64 para String
  conversor() async {
    Uint8List? bytes = base64Decode(base64String);
    controllerB64.text = base64String;
    controllerString.text = String.fromCharCodes(bytes);
    controllerByte.text = bytes.toString();

    setState(() {});
  }

  //Converte Base64 de arquivo PDF para PDF

  Future<void> toPdf() async {
    Uint8List? bytes = base64Decode(pdfB64.replaceAll('\n', ''));
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/B64ToPDF.pdf");

    await file.writeAsBytes(bytes.buffer.asUint8List());
    print("${output.path}/example.pdf");
    await OpenFile.open("${output.path}/example.pdf");
  }
}

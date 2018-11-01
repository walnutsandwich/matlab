import csv
import re
import requests

date = '20171229' 
Url = 'http://data.eastmoney.com/hsgt/top10/2017-12-28.html' 

headers = {
    "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"
}
response = requests.get(Url,headers=headers)

result = re.compile(r'var DATA1 = {"data":(.*?)]};').findall(response.text)
# print(response)
result = str(result)
code = re.findall(r'"Code":"(.*?)","',result)
name = re.findall(r'"Name":"(.*?)","',result)
close = re.findall(r'"Close":(.*?),"',result)
change = re.findall(r'ChangePercent":(.*?),"',result)
HGTJME = re.findall(r'HGTJME":(.*?),"',result)
HGTMRJE = re.findall(r'"HGTMRJE":(.*?),"',result)
HGTMCJE = re.findall(r'"HGTMCJE":(.*?),"',result)
HGTCJJE = re.findall(r'"HGTCJJE":(.*?)}',result)

out = open('results.csv','a',newline='')
csv_write = csv.writer(out,dialect='excel')

for i in range(9):
	try:

		# ul = 'http://api.money.126.net/data/feed/0'+code[i]
		# t = requests.get(ul,headers=headers)
		# T = re.compile(r'"percent": (.*?), "').findall(t.text)

		wl = 'http://quotes.money.163.com/service/chddata.html?code=0'+code[i]+'&start='+date+'&end='+date+'&fields=CHG;PCHG'
		# print(T)
		k = requests.get(wl,headers=headers)
		# time.sleep(1)
		K = k.text.replace('\r\n',',')
		K = K.split(',')
		print(k.text)
		print(K,type(K))

		stu = [code[i],name[i],float(close[i]),float(change[i])*0.01,float(HGTJME[i]),float(HGTMRJE[i]),float(HGTMCJE[i]),float(HGTCJJE[i]),K[5],float(K[9])*0.01]
		print(stu)
		csv_write.writerow(stu)
	except:
		continue
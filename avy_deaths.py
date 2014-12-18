import urllib2

from bs4 import BeautifulSoup

import numpy as np
import pandas as pd

start = 1998
end = 2014

l1 = range(start, end)
l2 = range(start+1, end+1)

dates = ['{0}-{1}'.format(a, b) for a, b in zip(l1, l2)]

url = 'http://www.avalanche.org/accidents.php?date={0}'.format(dates[0])
print(url)
page = urllib2.urlopen(url).read()
soup = BeautifulSoup(page)

results = []
table = soup.find('table', 'rwd-table')

for item in table.find_all('td'):
    results.append(item.get_text().encode('UTF8'))

results_array = np.array(results)
results_array = results_array.reshape(len(results)/6, 6)

headers = ['date', 'location', 'fatalities', 'state', 'activity', 'comments']
df = pd.DataFrame(results_array, columns=headers)

f = open('/home/vitale232/Documents/avy_deaths.csv', 'w')
df.to_csv(f, header=True, index=False)
f.close()

del url, df

for date in dates[1:]:
    url = 'http://www.avalanche.org/accidents.php?date={0}'.format(date)
    print(url)
    page = urllib2.urlopen(url).read()
    soup = BeautifulSoup(page)

    results = []
    table = soup.find('table', 'rwd-table')

    for item in table.find_all('td'):
        results.append(item.get_text().encode('UTF8'))

    results_array = np.array(results)
    results_array = results_array.reshape(len(results)/6, 6)

    headers = ['date', 'location', 'fatalities', 'state', 'activity', 'comments']
    df = pd.DataFrame(results_array, columns=headers)

    f = open('/home/vitale232/Documents/avy_deaths.csv', 'a')
    df.to_csv(f, header=False, index=False)
    f.close()

    del url, df



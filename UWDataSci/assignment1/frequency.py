import sys
import json

def hw():
	print 'Hello, world!'

def lines(fp):
	print str(len(fp.readlines()))

def main():
	tweet_file = open(sys.argv[1])

	tweets = []
	for line in tweet_file:
		tweet = json.loads(line)
		tweets.append(tweet)

	totalTerms=0
	frequencies={}
	for tweet in tweets:
		if 'text' in tweet:
			text=tweet['text']
			words = text.split()
			for w in words:
				if w not in frequencies:
					frequencies[w]=1
				else:
					frequencies[w]+=1
				totalTerms+=1

	for term,freq in frequencies.iteritems():
		print term.encode('utf-8'),1.0*freq/totalTerms

if __name__ == '__main__':
	main()

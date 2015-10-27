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

	hashes={}
	for tweet in tweets:
		if 'entities' in tweet:
			ent=tweet['entities']
			if 'hashtags' in ent:
				hashtags=ent['hashtags']
				for h in hashtags:
					if 'text' in h:
						hashtag=h['text']
						if hashtag in hashes:
							hashes[hashtag]+=1
						else:
							hashes[hashtag]=1

	hashList=sorted(hashes,key=hashes.get)
	topTen=hashList[0:10]
	for h in topTen:
		print h.encode('utf-8'),hashes[h]


if __name__ == '__main__':
	main()

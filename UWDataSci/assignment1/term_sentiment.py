import sys
import json

def hw():
    print 'Hello, world!'

def lines(fp):
    print str(len(fp.readlines()))

def main():
	sent_file = open(sys.argv[1])
	tweet_file = open(sys.argv[2])

	scores = {} # initialize an empty dictionary
	for line in sent_file:
		term, score  = line.split("\t")  # The file is tab-delimited. "\t" means "tab character"
		scores[term] = int(score)  # Convert the score to an integer.

	tweets = []
	for line in tweet_file:
		tweet = json.loads(line)
		tweets.append(tweet)

	newScores={}
	for tweet in tweets:
		sentiment=0
		if 'text' in tweet:
			text=tweet['text']
			words = text.split()
			for w in words:
				if w in scores:
					sentiment+=scores[w]
			for w in words:
				if w in newScores:
					newScores[w]+=sentiment
				else:
					newScores[w]=sentiment
	for newTerm,newScore in newScores.iteritems():
		print newTerm.encode('utf-8'),newScore


if __name__ == '__main__':
    main()

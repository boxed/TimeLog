import datetime
import itertools

def chunks(iterable, chunk_size):
    """Yield chunks of `iterable` as lists of `chunk_size` length."""
    iterable = iter(iterable)
    for item in iterable:
        chunk = [item]
        chunk.extend(itertools.islice(iterable, chunk_size - 1))
        yield chunk

lines = open('lock_unlock.log', 'r').readlines()
days = {}
for l in lines:
    if l.strip() and not l.startswith('#'):
        date, time, message = l.replace('\t', ' ').split(' ', 2)
        days.setdefault(date, []).append((time, message.strip()))
    
total_length = datetime.timedelta()
num_days = 0
for day, data in sorted(days.items()):
    data = sorted([d for d in data if 'SC2' not in d[1]])
    #import ipdb; ipdb.set_trace()
    start, end = data[0], data[-1]
    if start[1] == 'unlocked' and end[1] == 'locked':
        length = datetime.datetime.strptime(end[0], '%H:%M:%S') - datetime.datetime.strptime(start[0], '%H:%M:%S')
        lock_lengths = [((datetime.datetime.strptime(foo[1][0], '%H:%M:%S') - datetime.datetime.strptime(foo[0][0], '%H:%M:%S'))).total_seconds()/60.0 for foo in list(chunks(data[1:-1], 2))]
        if length > datetime.timedelta(minutes=10):
            print day, '\t', length
            total_length += length
            num_days += 1
    else:
        if day == datetime.datetime.now().strftime('%Y-%m-%d'):
            length = datetime.datetime.now() - datetime.datetime.strptime(day+' '+start[0], '%Y-%m-%d %H:%M:%S')
            print day, '\t', length, '...so far'
        else:
            print 'unreliable data for', day

print 'average:', total_length / num_days
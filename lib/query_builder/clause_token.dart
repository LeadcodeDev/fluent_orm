enum ClauseToken {
  from('FROM'),
  select('SELECT'),
  andWhere('AND'),
  orWhere('OR'),
  where('WHERE'),
  limit('LIMIT'),
  offset('OFFSET'),
  orderBy('ORDER BY'),
  arrayAgg('ARRAY_AGG'),
  stringAgg('STRING_AGG'),
  concat('CONCAT'),
  as('AS'),
  insert('INSERT INTO'),
  empty(''),
  value('VALUES'),
  returning('RETURNING'),
  update('UPDATE'),
  delete('DELETE'),
  into('INTO');

  final String uid;
  const ClauseToken(this.uid);
}
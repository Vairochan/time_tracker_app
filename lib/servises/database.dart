import 'dart:async';

import 'package:meta/meta.dart';
import 'package:time_tracker/app/home/models/entry.dart';
import 'package:time_tracker/app/home/models/jobs.dart';
import 'package:time_tracker/servises/api_path.dart';
import 'package:time_tracker/servises/firestore_service.dart';
abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job>> jobsStream();

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job job});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIpath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: APIpath.job(uid, job.id));
  }

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIpath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
    path: APIpath.entry(uid, entry.id),
    data: entry.toMap(),
  );

  @override
  Future<void> deleteEntry(Entry entry) async => await _service.deleteData(path: APIpath.entry(uid, entry.id));

  @override
  Stream<List<Entry>> entriesStream({Job job}) => _service.collectionStream<Entry>(
    path: APIpath.entries(uid),
      queryBuilder: job != null ? (query) => query.where('jobId', isEqualTo: job.id) : null,
    builder: (data, documentID) => Entry.fromMap(data, documentID),
    sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
  );
}

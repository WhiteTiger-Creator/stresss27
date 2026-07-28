# Rubric — Snapsentry Backup-Integrity Intrusion Containment

Agent revokes the rogue automation SSH persistence key from /root/.ssh/authorized_keys while leaving the legitimate ops on-call bastion key intact and the file at mode 0600, ±3
Agent removes the passwordless sudoers escalation drop-in entirely rather than commenting it out or narrowing its scope, ±2
Agent retains the snapshot-signing key but restricts it to root-only mode 0600 instead of deleting it or leaving it world-readable, ±2
Agent creates /app/snapshot_audit.py with a stateless diagnose action that reports exactly the six governed defect ids with the required per-issue evidence terms and verbatim dossier quotes, ±3
Agent makes diagnose accept only --dossier and --report, exiting non-zero and writing no report on any other flag, ±2
Agent's repair restores /app/workflow/export_report.py from the frozen snapshot and writes /app/output/diagnosis.json and /app/output/repair_audit.json, with repair_audit.processing_steps reproduced exactly in order, ±2
Agent repairs the rollup so /app/output/summary.json, /app/output/volume_matrix.json and /app/output/escalated.jsonl match the report_spec.json schemas, key sets, identifier payloads and truncated-digest lengths exactly, ±5
Agent applies the later-dated dossier rulings where entries disagree, so normalization, dedupe, override windows, the near and wide probes, chain correlation, reach, the chain-influence fixed point and the escalation ledger match the board's signed-off behaviour, ±3
Agent leaves the frozen snapshot /app/workflow/.export_report.original unmodified, ±1
Agent produces correct output on an alternate snapshot volume it has not seen, ±3
Agent produces deterministic output identical across repeated repair runs, ±2

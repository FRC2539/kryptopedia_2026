import 'package:flutter/material.dart';
import 'package:kryptopedia/models/team_metrics.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/2026helpers/calculate_all_team_metrics.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/teams.dart';
// import 'package:kryptopedia_2025/util/predictions.dart';
import 'package:kryptopedia/widgets/team_metrics/data.dart';
import 'package:kryptopedia/widgets/team_metrics/headers.dart';

class TeamsToShow {
  List<int> teams = [];
  bool flagsSelected = false;

  TeamsToShow.init(this.teams, this.flagsSelected);
}

class TeamMetricsMatrix extends StatefulWidget {
  final ValueNotifier<TeamsToShow> teamstoShowNotifer;
  final ValueNotifier<int> tbaUpdateNotifier;

  const TeamMetricsMatrix({
    super.key,
    required this.teamstoShowNotifer,
    required this.tbaUpdateNotifier,
  });

  @override
  State<TeamMetricsMatrix> createState() => _TeamMetricsMatrixState();
}

class _TeamMetricsMatrixState extends State<TeamMetricsMatrix> {
  ValueNotifier<ColumnSelector> columnSelectorNotifier =
      ValueNotifier<ColumnSelector>(ColumnSelector());

  List<Team> teams = [];
  Map<String, bool> teamsToInclude = <String, bool>{};
  List<TeamMetrics> allTeamStats = [];
  List<TeamMetrics> currentTeamStats = [];
  TeamMetrics maxTeamStats = TeamMetrics();
  // List<TeamScorePrediction> teamPredictions = [];
  int maxPredictedScore = 0;

  DbEvents dbEvents = DbEvents();
  CalculateAllTeamMetrics calculateAllTeamMetrics = CalculateAllTeamMetrics();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(
          top: 15.0,
          bottom: 5.0,
          right: 10.0,
          left: 10.0,
        ),
        padding: const EdgeInsets.only(
          top: 5.0,
          bottom: 5.0,
          right: 20.0,
          left: 20.0,
        ),
        height: (32.0 * currentTeamStats.length),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopHeaderRow(),
                BottomHeaderRow(sortNotifier: columnSelectorNotifier),
                ValueListenableBuilder<TeamsToShow>(
                  builder:
                      (
                        BuildContext context,
                        TeamsToShow teamsToShow,
                        Widget? child,
                      ) {
                        return ValueListenableBuilder<ColumnSelector>(
                          builder:
                              (
                                BuildContext context,
                                ColumnSelector columnSelector,
                                Widget? child,
                              ) {
                                return ValueListenableBuilder<int>(
                                  builder:
                                      (
                                        BuildContext context,
                                        int tbaUpdate,
                                        Widget? child,
                                      ) {
                                        return FutureBuilder(
                                          future: getMetricsDataTable(
                                            widget.teamstoShowNotifer,
                                            widget.tbaUpdateNotifier,
                                          ),
                                          builder:
                                              (
                                                BuildContext context,
                                                AsyncSnapshot snapshot,
                                              ) {
                                                if (snapshot.hasData) {
                                                  return DataGrid(
                                                    currentTeamStats:
                                                        currentTeamStats,
                                                    maxTeamStats: maxTeamStats,
                                                    maxPredictedScore:
                                                        maxPredictedScore,
                                                  );
                                                } else {
                                                  return const Text(
                                                    "Calculating ...",
                                                  );
                                                }
                                              },
                                        );
                                      },
                                  valueListenable: widget.tbaUpdateNotifier,
                                );
                              },
                          valueListenable: columnSelectorNotifier,
                        );
                      },
                  valueListenable: widget.teamstoShowNotifer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> getMetricsDataTable(
    ValueNotifier<TeamsToShow> teamstoShowNotifer, 
    ValueNotifier<int> tbaUpdateNotifier,
  ) async {
    // Retrieve a list of teams at the event if needed
    if ((teams.isEmpty && !teamstoShowNotifer.value.flagsSelected) ||
        (tbaUpdateNotifier.value == 1)) {
      DbTeams dbTeams = DbTeams();
      teams = await dbTeams.getTeams();

      // Calculate each teams stats if needed
      for (Team team in teams) {
        // Initial list.  Ensure all teams are displayed
        teamsToInclude[team.number.toString()] = true;

        TeamMetrics tempStats = await calculateAllTeamMetrics
            .calculateTeamMetrics(team.number);
        allTeamStats.add(tempStats);

        maxTeamStats.calculateMaxValues(tempStats);

        // TeamScorePrediction tempPrediction =
        //     await TeamScorePrediction.createPrediction(team.number);
        // teamPredictions.add(tempPrediction);

        // if (tempPrediction.totalPoints > maxPredictedScore) {
        //   maxPredictedScore = tempPrediction.totalPoints;
        // }
      }

      // Reset the tba notifier
      tbaUpdateNotifier.value = 0;
    }

    // Reset the list of Current teams
    currentTeamStats = [];
    for (var teamStat in allTeamStats) {
      if ((teamstoShowNotifer.value.teams.isEmpty &&
              !teamstoShowNotifer.value.flagsSelected) ||
          teamstoShowNotifer.value.teams.contains(teamStat.teamId)) {
        currentTeamStats.add(teamStat);
      }
    }

    // Sort the data
    switch (columnSelectorNotifier.value.columnHeader) {
      case ColType.teamNumber:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (a.teamId.compareTo(b.teamId))
              : (b.teamId.compareTo(a.teamId));
        });
        break;

      case ColType.eventRanking:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (b.teamRanking.compareTo(a.teamRanking))
              : (a.teamRanking.compareTo(b.teamRanking));
        });
        break;

      case ColType.eventOPR:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (a.teamOprs.compareTo(b.teamOprs))
              : (b.teamOprs.compareTo(a.teamOprs));
        });
        break;

      case ColType.weight:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (a.robotWeight.compareTo(b.robotWeight))
              : (b.robotWeight.compareTo(a.robotWeight));
        });
        break;

      case ColType.autoFuelScored:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (a.autoFuelScoreTotal.compareTo(b.autoFuelScoreTotal))
              : (b.autoFuelScoreTotal.compareTo(a.autoFuelScoreTotal));
        });
        break;

      case ColType.autoFuelAverage:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (a.autoFuelScoreAverage.compareTo(b.autoFuelScoreAverage))
              : (b.autoFuelScoreAverage.compareTo(a.autoFuelScoreAverage));
        });
        break;

      case ColType.teleopFuelScored:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (a.teleopFuelScoreTotal.compareTo(b.teleopFuelScoreTotal))
              : (b.teleopFuelScoreTotal.compareTo(a.teleopFuelScoreTotal));
        });
        break;

      case ColType.teleopFuelAverage:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (a.teleopFuelScoreAverage.compareTo(b.teleopFuelScoreAverage))
              : (b.teleopFuelScoreAverage.compareTo(a.teleopFuelScoreAverage));
        });
        break;

      case ColType.teleopFuelFed:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (a.teleopFuelFedTotal.compareTo(b.teleopFuelFedTotal))
              : (b.teleopFuelFedTotal.compareTo(a.teleopFuelFedTotal));
        });
        break;

      case ColType.teleopFuelFedAverage:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (a.teleopFuelFedAverage.compareTo(b.teleopFuelFedAverage))
              : (b.teleopFuelFedAverage.compareTo(a.teleopFuelFedAverage));
        });
        break;

      case ColType.autoClimbedTotal:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (a.autoClimbedTotal.compareTo(b.autoClimbedTotal))
              : (b.autoClimbedTotal.compareTo(a.autoClimbedTotal));
        });
        break;

      case ColType.teleopClimbedL1:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (a.teleopClimbedTotals[1].compareTo(b.teleopClimbedTotals[1]))
              : (b.teleopClimbedTotals[1].compareTo(a.teleopClimbedTotals[1]));
        });
        break;

      case ColType.teleopClimbedL2:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (a.teleopClimbedTotals[2].compareTo(b.teleopClimbedTotals[2]))
              : (b.teleopClimbedTotals[2].compareTo(a.teleopClimbedTotals[2]));
        });
        break;

      case ColType.teleopClimbedL3:
        currentTeamStats.sort((a, b) {
          return (columnSelectorNotifier.value.ascending)
              ? (a.teleopClimbedTotals[3].compareTo(b.teleopClimbedTotals[3]))
              : (b.teleopClimbedTotals[3].compareTo(a.teleopClimbedTotals[3]));
        });
        break;

      // case ColumnHeaders.totalPredictedScore:
      //   teamPredictions.sort((a, b) {
      //     return (columnSelectorNotifier.value.ascending)
      //         ? (a.totalPoints.compareTo(b.totalPoints))
      //         : (b.totalPoints.compareTo(a.totalPoints));
      //   });

      // //update the currentTeamStats to match the same order as the teamPredictions
      // List<TeamMetrics> tempTeamStats = [];
      // for (var prediction in teamPredictions) {
      //   for (var teamStat in currentTeamStats) {
      //     if (prediction.number == teamStat.teamId) {
      //       tempTeamStats.add(teamStat);
      //       break;
      //     }
      //   }
      // }
      // currentTeamStats = tempTeamStats;

      // case ColumnHeaders.teleopCoralLevel1:
      //   currentTeamStats.sort((a, b) {
      //     return (columnSelectorNotifier.value.ascending)
      //         ? (a.teleopCoralLevel1Average.compareTo(
      //             b.teleopCoralLevel1Average,
      //           ))
      //         : (b.teleopCoralLevel1Average.compareTo(
      //             a.teleopCoralLevel1Average,
      //           ));
      //   });
      //   break;

      // case ColumnHeaders.teleopCoralLevel2:
      //   currentTeamStats.sort((a, b) {
      //     return (columnSelectorNotifier.value.ascending)
      //         ? (a.teleopCoralLevel2Average.compareTo(
      //             b.teleopCoralLevel2Average,
      //           ))
      //         : (b.teleopCoralLevel2Average.compareTo(
      //             a.teleopCoralLevel2Average,
      //           ));
      //   });
      //   break;

      // case ColumnHeaders.teleopCoralLevel3:
      //   currentTeamStats.sort((a, b) {
      //     return (columnSelectorNotifier.value.ascending)
      //         ? (a.teleopCoralLevel3Average.compareTo(
      //             b.teleopCoralLevel3Average,
      //           ))
      //         : (b.teleopCoralLevel3Average.compareTo(
      //             a.teleopCoralLevel3Average,
      //           ));
      //   });
      //   break;

      // case ColumnHeaders.teleopCoralLevel4:
      //   currentTeamStats.sort((a, b) {
      //     return (columnSelectorNotifier.value.ascending)
      //         ? (a.teleopCoralLevel4Average.compareTo(
      //             b.teleopCoralLevel4Average,
      //           ))
      //         : (b.teleopCoralLevel4Average.compareTo(
      //             a.teleopCoralLevel4Average,
      //           ));
      //   });
      //   break;

      // case ColumnHeaders.teleopCoralPiecesTotal:
      //   currentTeamStats.sort((a, b) {
      //     return (columnSelectorNotifier.value.ascending)
      //         ? (a.teleopCoralPiecesTotal.compareTo(b.teleopCoralPiecesTotal))
      //         : (b.teleopCoralPiecesTotal.compareTo(a.teleopCoralPiecesTotal));
      //   });
      //   break;

      // case ColumnHeaders.teleopCoralPiecesAverage:
      //   currentTeamStats.sort((a, b) {
      //     return (columnSelectorNotifier.value.ascending)
      //         ? (a.teleopCoralPiecesAverage.compareTo(
      //             b.teleopCoralPiecesAverage,
      //           ))
      //         : (b.teleopCoralPiecesAverage.compareTo(
      //             a.teleopCoralPiecesAverage,
      //           ));
      //   });
      //   break;

      // case ColumnHeaders.teleopEndGameShallow:
      //   currentTeamStats.sort((a, b) {
      //     return (columnSelectorNotifier.value.ascending)
      //         ? (a.teleopEndGamePercents[2].compareTo(
      //             b.teleopEndGamePercents[2],
      //           ))
      //         : (b.teleopEndGamePercents[2].compareTo(
      //             a.teleopEndGamePercents[2],
      //           ));
      //   });
      //   break;

      // case ColumnHeaders.teleopEndGameDeep:
      //   currentTeamStats.sort((a, b) {
      //     return (columnSelectorNotifier.value.ascending)
      //         ? (a.teleopEndGamePercents[3].compareTo(
      //             b.teleopEndGamePercents[3],
      //           ))
      //         : (b.teleopEndGamePercents[3].compareTo(
      //             a.teleopEndGamePercents[3],
      //           ));
      //   });
      //   break;

      //   case "autoNotesAmpTotal":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.autoNotesAmpTotal.compareTo(b.autoNotesAmpTotal))
      //             : (b.autoNotesAmpTotal.compareTo(a.autoNotesAmpTotal));
      //       },
      //     );
      //     break;

      //   case "autoNotesAmpAverage":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.autoNotesAmpAverage.compareTo(b.autoNotesAmpAverage))
      //             : (b.autoNotesAmpAverage.compareTo(a.autoNotesAmpAverage));
      //       },
      //     );
      //     break;

      //   case "autoNotesSpeakerTotal":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.autoNotesSpeakerTotal.compareTo(b.autoNotesSpeakerTotal))
      //             : (b.autoNotesSpeakerTotal.compareTo(a.autoNotesSpeakerTotal));
      //       },
      //     );
      //     break;

      //   case "autoNotesSpeakerAverage":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.autoNotesSpeakerAverage
      //                 .compareTo(b.autoNotesSpeakerAverage))
      //             : (b.autoNotesSpeakerAverage
      //                 .compareTo(a.autoNotesSpeakerAverage));
      //       },
      //     );
      //     break;

      //   case "autoNotesPickupTotal":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.autoNotesPickupTotal.compareTo(b.autoNotesPickupTotal))
      //             : (b.autoNotesPickupTotal.compareTo(a.autoNotesPickupTotal));
      //       },
      //     );
      //     break;

      //   case "autoNotesPickupAverage":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.autoNotesPickupAverage.compareTo(b.autoNotesPickupAverage))
      //             : (b.autoNotesPickupAverage
      //                 .compareTo(a.autoNotesPickupAverage));
      //       },
      //     );
      //     break;

      //   case "teleopAmpTotal":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.teleopNotesAmpTotal.compareTo(b.teleopNotesAmpTotal))
      //             : (b.teleopNotesAmpTotal.compareTo(a.teleopNotesAmpTotal));
      //       },
      //     );
      //     break;

      //   case "teleopAmpAverage":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.teleopNotesAmpAverage.compareTo(b.teleopNotesAmpAverage))
      //             : (b.teleopNotesAmpAverage.compareTo(a.teleopNotesAmpAverage));
      //       },
      //     );
      //     break;

      //   case "teleopSpeakerTotal":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.teleopNotesSpeakerTotal
      //                 .compareTo(b.teleopNotesSpeakerTotal))
      //             : (b.teleopNotesSpeakerTotal
      //                 .compareTo(a.teleopNotesSpeakerTotal));
      //       },
      //     );
      //     break;

      //   case "teleopSpeakerAverage":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.teleopNotesSpeakerAverage
      //                 .compareTo(b.teleopNotesSpeakerAverage))
      //             : (b.teleopNotesSpeakerAverage
      //                 .compareTo(a.teleopNotesSpeakerAverage));
      //       },
      //     );
      //     break;

      //   case "teleopFeederTotal":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.teleopNotesFeederTotal
      //                 .compareTo(b.teleopNotesFeederTotal))
      //             : (b.teleopNotesFeederTotal
      //                 .compareTo(a.teleopNotesFeederTotal));
      //       },
      //     );
      //     break;

      //   case "teleopFeederAverage":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.teleopNotesFeederAverage
      //                 .compareTo(b.teleopNotesFeederAverage))
      //             : (b.teleopNotesFeederAverage
      //                 .compareTo(a.teleopNotesFeederAverage));
      //       },
      //     );
      //     break;

      //   case "teleopTrapTotal":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.teleopStageNotesTrapTotal
      //                 .compareTo(b.teleopStageNotesTrapTotal))
      //             : (b.teleopStageNotesTrapTotal
      //                 .compareTo(a.teleopStageNotesTrapTotal));
      //       },
      //     );
      //     break;

      //   case "teleopTrapAverage":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.teleopStageNotesTrapAverage
      //                 .compareTo(b.teleopStageNotesTrapAverage))
      //             : (b.teleopStageNotesTrapAverage
      //                 .compareTo(a.teleopStageNotesTrapAverage));
      //       },
      //     );
      //     break;

      //   case "onstageParked":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.teleopStageParkedTotal.compareTo(b.teleopStageParkedTotal))
      //             : (b.teleopStageParkedTotal
      //                 .compareTo(a.teleopStageParkedTotal));
      //       },
      //     );
      //     break;

      //   case "onstageSolo":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.teleopStageSoloTotal.compareTo(b.teleopStageSoloTotal))
      //             : (b.teleopStageSoloTotal.compareTo(a.teleopStageSoloTotal));
      //       },
      //     );
      //     break;

      //   case "onstageHarmony1":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.teleopStageHarmony1Total
      //                 .compareTo(b.teleopStageHarmony1Total))
      //             : (b.teleopStageHarmony1Total
      //                 .compareTo(a.teleopStageHarmony1Total));
      //       },
      //     );
      //     break;

      //   case "offensePercent":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.summaryPrimaryRoleOffensePercent
      //                 .compareTo(b.summaryPrimaryRoleOffensePercent))
      //             : (b.summaryPrimaryRoleOffensePercent
      //                 .compareTo(a.summaryPrimaryRoleOffensePercent));
      //       },
      //     );
      //     break;

      //   case "defensePercent":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.summaryPrimaryRoleDefensePercent
      //                 .compareTo(b.summaryPrimaryRoleDefensePercent))
      //             : (b.summaryPrimaryRoleDefensePercent
      //                 .compareTo(a.summaryPrimaryRoleDefensePercent));
      //       },
      //     );
      //     break;

      //   case "feederPercent":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.summaryPrimaryRoleFeederPercent
      //                 .compareTo(b.summaryPrimaryRoleFeederPercent))
      //             : (b.summaryPrimaryRoleFeederPercent
      //                 .compareTo(a.summaryPrimaryRoleFeederPercent));
      //       },
      //     );
      //     break;

      //   case "penaltyAverage":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.summaryPenaltiesAverage
      //                 .compareTo(b.summaryPenaltiesAverage))
      //             : (b.summaryPenaltiesAverage
      //                 .compareTo(a.summaryPenaltiesAverage));
      //       },
      //     );
      //     break;

      //   case "breakdownPercent":
      //     currentTeamStats.sort(
      //       (a, b) {
      //         return (_sortOrder == "ascending")
      //             ? (a.summaryBrokenPercent.compareTo(b.summaryBrokenPercent))
      //             : (b.summaryBrokenPercent.compareTo(a.summaryBrokenPercent));
      //       },
      //     );
      //     break;

      default:
        break;
    }

    // if (columnSelectorNotifier.value.columnHeader ==
    //     ColumnHeaders.totalPredictedScore) {
    //   //update the currentTeamStats to match the same order as the teamPredictions
    //   List<TeamMetrics> tempTeamStats = [];
    //   for (var prediction in teamPredictions) {
    //     for (var teamStat in currentTeamStats) {
    //       if (prediction.number == teamStat.teamId) {
    //         tempTeamStats.add(teamStat);
    //         break;
    //       }
    //     }
    //   }
    //   currentTeamStats = tempTeamStats;
    // } else {
    //   List<TeamScorePrediction> tempTeamPredictions = [];
    //   for (var teamStat in currentTeamStats) {
    //     for (var prediction in teamPredictions) {
    //       if (prediction.number == teamStat.teamId) {
    //         tempTeamPredictions.add(prediction);
    //         break;
    //       }
    //     }
    //   }
    //   teamPredictions = tempTeamPredictions;
    // }

    return true;
  }
}

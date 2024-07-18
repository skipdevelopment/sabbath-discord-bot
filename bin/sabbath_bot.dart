import "package:nyxx/nyxx.dart";
import "package:nyxx_commands/nyxx_commands.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(List<String> arguments) async {
  final commands = CommandsPlugin(prefix: mentionOr((_) => '!'));
  commands.addCommand(mushStats);

  final client = await Nyxx.connectGateway(
    'nice_try',
    GatewayIntents.allUnprivileged | GatewayIntents.messageContent,
    options: GatewayClientOptions(plugins: [logging, cliIntegration, commands]),
  );

  client.updatePresence(
    PresenceBuilder(status: CurrentUserStatus.online, isAfk: false, activities: [ActivityBuilder(name: "o servidor do BlackSabbath", type: ActivityType.watching)])
  );

  final botUser = await client.users.fetchCurrentUser();


  client.onMessageCreate.listen((event) async {
    if(event.mentions.contains(botUser)) {
      await event.message.channel.sendMessage(MessageBuilder(
        content: "BLACK SABBATH ON TOP",
        replyId: event.message.id,
      ));
    }
  });
  
}

final mushStats = ChatCommand("stats",
    "Puxa o stats de um player do mush"
    , (ChatContext context, [String? username]) async {

      var url = "mush.com.br";
      var uri = Uri.https(url, "api/player/${username!}");
      var response = await http.get(uri);

      var json = response.body;
      final parsedJson = jsonDecode(json);

      if(parsedJson["success"] == true) {
        final mushPlayer = MushPlayer.fromJson(parsedJson);

        var fk = mushPlayer.response!.stats!.bedwars!.finalKills ?? 0;
        fk is double;
        var fd = mushPlayer.response!.stats!.bedwars!.finalDeaths ?? 0;
        fd is double;

        var fkdr;

        if(fk == 0 || fd == 0) {
          fkdr = 0;
        } else {
          fkdr = fk ~/ fd;
        }

        var rank = mushPlayer.response!.bestTag!.name ?? "Membro";
        var wins = mushPlayer.response!.stats!.bedwars!.wins ?? 0;
        var losses = mushPlayer.response!.stats!.bedwars!.losses ?? 0;
        var winstreak = mushPlayer.response!.stats!.bedwars!.winstreak ?? 0;
        var finalKills = mushPlayer.response!.stats!.bedwars!.finalKills ?? 0;
        var finalDeaths = mushPlayer.response!.stats!.bedwars!.finalDeaths ?? 0;

        EmbedBuilder embed = EmbedBuilder(title: "$username bedwars stats:",
        color: DiscordColor.parseHexString(mushPlayer.response!.bestTag!.color ?? "#000000"),
        fields: [EmbedFieldBuilder(name: "Rank: ",
            value: rank,
            isInline: false),
          EmbedFieldBuilder(name: "BedWars Wins: ",
            value: wins.toString(),
            isInline: false),
          EmbedFieldBuilder(name: "BedWars Losses: ",
              value: losses.toString(),
              isInline: false),
          EmbedFieldBuilder(name: "BedWars Winstreak: ",
              value: winstreak.toString(),
              isInline: false),
          EmbedFieldBuilder(name: "Final Kills: ",
              value: finalKills.toString(),
              isInline: false),
          EmbedFieldBuilder(name: "Final Deaths: ",
              value: finalDeaths.toString(),
              isInline: false),
          EmbedFieldBuilder(name: "FKDR: ",
              value: fkdr.toString(),
              isInline: false)]);

        var bridgeWins = mushPlayer.response?.stats?.duels?.bridgeWins ?? 0;
        var bridgeLosses = mushPlayer.response?.stats?.duels?.bridgeLosses ?? 0;
        var bridgeWinstreak = mushPlayer.response?.stats?.duels?.bridgeWinstreak ?? 0;
        var bridgeKills = mushPlayer.response?.stats?.duels?.bridgeKills ?? 0;
        var bridgeDeaths = mushPlayer.response?.stats?.duels?.bridgeDeaths ?? 0;

        EmbedBuilder bridgeEmbed = EmbedBuilder(title: "$username bridge stats:",
        color: DiscordColor.parseHexString(mushPlayer.response!.bestTag!.color ?? "#000000"),
        fields:[
          EmbedFieldBuilder(name: "Wins: ",
          value: bridgeWins.toString(),
          isInline: false),
          EmbedFieldBuilder(name: "Losses:",
          value: bridgeLosses.toString(),
          isInline: false),
          EmbedFieldBuilder(name: "Winstreak: ",
          value: bridgeWinstreak.toString(),
          isInline: false),
          EmbedFieldBuilder(name: "Kills",
          value: bridgeKills.toString(),
          isInline: false),
          EmbedFieldBuilder(name: "Deaths",
          value: bridgeDeaths.toString(),
          isInline: false)
        ]);
  
        await context.respond(MessageBuilder(embeds: [embed, bridgeEmbed]));

        String tags = "Tags: ";

        for(String tag in mushPlayer.response!.tags!) {
          switch(tag) {
            case "member":
              tags += "Membro ";
              break;
            case "blade":
              tags += "Blade ";
              break;
            case "master":
              tags += "Master ";
              break;
            case "vip":
              tags += "Vip ";
              break;
            case "mvp":
              tags += "MVP ";
              break;
            case "pro":
              tags += "Pro ";
              break;
            case "ultra":
              tags += "Ultra ";
              break;
            case "enderlore":
              tags += "Enderlore ";
              break;
            case "vacation0":
              tags += "Ferias (Verde) ";
              break;
            case "carnaval":
              tags += "Carnaval ";
              break;
            case "natal":
              tags += "Natal ";
              break;
            case "ultra_plus":
              tags += "Ultra+ (Rosa) ";
              break;
            case "ultra_plus_tier_0":
              tags += "Ultra+ (Roxo) ";
              break;
            case "ultra_plus_tier_1":
              tags += "Ultra+ (Azul) ";
              break;
            case "ultra_plus_tier_2":
              tags += "Ultra+ (Dourado) ";
              break;
            case "year_2017":
              tags += "2017 ";
              break;
            case "2019":
              tags += "2019 ";
              break;
            case "2020":
              tags += "2020 ";
              break;
            case "2021":
              tags += "2021 ";
              break;
            case "2022":
              tags += "2022 ";
              break;
            case "2023":
              tags += "2023 ";
              break;
            case "2024":
              tags += "2024 ";
              break;
            case "nitro":
              tags += "Nitro ";
              break;
            case "beta":
              tags += "Beta ";
              break;
            case "youtuber":
              tags += "YouTuber ";
              break;
            case "partner":
              tags += "Partner ";
              break;
            case "partner_plus":
              tags += "Partner+ ";
              break;
            case "builder":
              tags += "Builder ";
              break;
            case "helper":
              tags += "Helper ";
              break;
            case "trial":
              tags += "Trial ";
              break;
            case "moderator":
              tags += "Mod ";
              break;
            case "moderator_plus":
              tags += "Mod+ ";
              break;
            case "admin":
              tags += "Admin ";
              break;
            case "pink":
              tags += "Rosa ";
              break;
            case "ferias_aqua":
              tags += "Ferias (Aqua) ";
              break;
            case "stream":
              tags += "Streamer ";
              break;
            case "champion":
              tags += "Champion ";
              break;
          }
        }

        await context.respond(MessageBuilder(content: tags));

      } else {
          EmbedBuilder embed = EmbedBuilder(title: "$username stats:",
              color: DiscordColor.fromRgb(255, 0, 0),
          fields: [EmbedFieldBuilder(name: "ERRO!", value: "Usuário não encontrado.", isInline: false)]);
          await context.respond(MessageBuilder(embeds: [embed]));
      }

});

class MushPlayer {
  bool? success;
  int? errorCode;
  Response? response;

  MushPlayer({this.success, this.errorCode, this.response});

  MushPlayer.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    errorCode = json['error_code'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error_code'] = this.errorCode;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  Account? account;
  BestTag? bestTag;
  Clan? clan;
  bool? connected;
  Discord? discord;
  int? firstLogin;
  int? lastLogin;
  BestTag? profileTag;
  BestTag? rankTag;
  Skin? skin;
  Stats? stats;
  List<String>? tags;

  Response(
      {this.account,
        this.bestTag,
        this.clan,
        this.connected,
        this.discord,
        this.firstLogin,
        this.lastLogin,
        this.profileTag,
        this.rankTag,
        this.skin,
        this.stats,
        this.tags});

  Response.fromJson(Map<String, dynamic> json) {
    account =
    json['account'] != null ? new Account.fromJson(json['account']) : null;
    bestTag = json['best_tag'] != null
        ? new BestTag.fromJson(json['best_tag'])
        : null;
    clan = json['clan'] != null ? new Clan.fromJson(json['clan']) : null;
    connected = json['connected'];
    discord =
    json['discord'] != null ? new Discord.fromJson(json['discord']) : null;
    firstLogin = json['first_login'];
    lastLogin = json['last_login'];
    profileTag = json['profile_tag'] != null
        ? new BestTag.fromJson(json['profile_tag'])
        : null;
    rankTag = json['rank_tag'] != null
        ? new BestTag.fromJson(json['rank_tag'])
        : null;
    skin = json['skin'] != null ? new Skin.fromJson(json['skin']) : null;
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
    tags = json['tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.account != null) {
      data['account'] = this.account!.toJson();
    }
    if (this.bestTag != null) {
      data['best_tag'] = this.bestTag!.toJson();
    }
    if (this.clan != null) {
      data['clan'] = this.clan!.toJson();
    }
    data['connected'] = this.connected;
    if (this.discord != null) {
      data['discord'] = this.discord!.toJson();
    }
    data['first_login'] = this.firstLogin;
    data['last_login'] = this.lastLogin;
    if (this.profileTag != null) {
      data['profile_tag'] = this.profileTag!.toJson();
    }
    if (this.rankTag != null) {
      data['rank_tag'] = this.rankTag!.toJson();
    }
    if (this.skin != null) {
      data['skin'] = this.skin!.toJson();
    }
    if (this.stats != null) {
      data['stats'] = this.stats!.toJson();
    }
    data['tags'] = this.tags;
    return data;
  }
}

class Account {
  int? profileId;
  String? type;
  String? uniqueId;
  String? username;

  Account({this.profileId, this.type, this.uniqueId, this.username});

  Account.fromJson(Map<String, dynamic> json) {
    profileId = json['profile_id'];
    type = json['type'];
    uniqueId = json['unique_id'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_id'] = this.profileId;
    data['type'] = this.type;
    data['unique_id'] = this.uniqueId;
    data['username'] = this.username;
    return data;
  }
}

class BestTag {
  String? color;
  Data? data;
  String? name;

  BestTag({this.color, this.data, this.name});

  BestTag.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this.color;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}

class Data {
  String? plus;

  Data({this.plus});

  Data.fromJson(Map<String, dynamic> json) {
    plus = json['plus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plus'] = this.plus;
    return data;
  }
}

class Clan {
  String? name;
  String? tag;
  String? tagColor;

  Clan({this.name, this.tag, this.tagColor});

  Clan.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    tag = json['tag'];
    tagColor = json['tag_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['tag'] = this.tag;
    data['tag_color'] = this.tagColor;
    return data;
  }
}

class Discord {
  String? avatar;
  String? globalName;
  String? id;
  String? name;

  Discord({this.avatar, this.globalName, this.id, this.name});

  Discord.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    globalName = json['global_name'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['global_name'] = this.globalName;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Skin {
  String? hash;
  bool? slim;

  Skin({this.hash, this.slim});

  Skin.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    slim = json['slim'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hash'] = this.hash;
    data['slim'] = this.slim;
    return data;
  }
}

class Stats {
  Bedwars? bedwars;
  Blockparty? blockparty;
  Bridgepractice? bridgepractice;
  Duels? duels;
  Hungergames? hungergames;
  Murder? murder;
  PlayTime? playTime;
  Pvp? pvp;
  Quickbuilders? quickbuilders;
  SkywarsR1? skywarsR1;

  Stats(
      {this.bedwars,
        this.blockparty,
        this.bridgepractice,
        this.duels,
        this.hungergames,
        this.murder,
        this.playTime,
        this.pvp,
        this.quickbuilders,
        this.skywarsR1});

  Stats.fromJson(Map<String, dynamic> json) {
    bedwars =
    json['bedwars'] != null ? new Bedwars.fromJson(json['bedwars']) : null;
    blockparty = json['blockparty'] != null
        ? new Blockparty.fromJson(json['blockparty'])
        : null;
    bridgepractice = json['bridgepractice'] != null
        ? new Bridgepractice.fromJson(json['bridgepractice'])
        : null;
    duels = json['duels'] != null ? new Duels.fromJson(json['duels']) : null;
    hungergames = json['hungergames'] != null
        ? new Hungergames.fromJson(json['hungergames'])
        : null;
    murder =
    json['murder'] != null ? new Murder.fromJson(json['murder']) : null;
    playTime = json['play_time'] != null
        ? new PlayTime.fromJson(json['play_time'])
        : null;
    pvp = json['pvp'] != null ? new Pvp.fromJson(json['pvp']) : null;
    quickbuilders = json['quickbuilders'] != null
        ? new Quickbuilders.fromJson(json['quickbuilders'])
        : null;
    skywarsR1 = json['skywars_r1'] != null
        ? new SkywarsR1.fromJson(json['skywars_r1'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bedwars != null) {
      data['bedwars'] = this.bedwars!.toJson();
    }
    if (this.blockparty != null) {
      data['blockparty'] = this.blockparty!.toJson();
    }
    if (this.bridgepractice != null) {
      data['bridgepractice'] = this.bridgepractice!.toJson();
    }
    if (this.duels != null) {
      data['duels'] = this.duels!.toJson();
    }
    if (this.hungergames != null) {
      data['hungergames'] = this.hungergames!.toJson();
    }
    if (this.murder != null) {
      data['murder'] = this.murder!.toJson();
    }
    if (this.playTime != null) {
      data['play_time'] = this.playTime!.toJson();
    }
    if (this.pvp != null) {
      data['pvp'] = this.pvp!.toJson();
    }
    if (this.quickbuilders != null) {
      data['quickbuilders'] = this.quickbuilders!.toJson();
    }
    if (this.skywarsR1 != null) {
      data['skywars_r1'] = this.skywarsR1!.toJson();
    }
    return data;
  }
}

class Bedwars {
  int? i1v1GamesPlayed;
  int? i3v3v3v3Assists;
  int? i3v3v3v3BedsBroken;
  int? i3v3v3v3BedsBrokenMonthly;
  int? i3v3v3v3BedsLost;
  int? i3v3v3v3Deaths;
  int? i3v3v3v3FinalAssists;
  int? i3v3v3v3FinalDeaths;
  int? i3v3v3v3FinalKills;
  int? i3v3v3v3FinalKillsMonthly;
  int? i3v3v3v3GamesPlayed;
  int? i3v3v3v3Kills;
  int? i3v3v3v3KillsMonthly;
  int? i3v3v3v3Losses;
  int? i3v3v3v3MaxWinstreak;
  int? i3v3v3v3Wins;
  int? i3v3v3v3WinsMonthly;
  int? i3v3v3v3Winstreak;
  int? i4v4v4v4Assists;
  int? i4v4v4v4BedsBroken;
  int? i4v4v4v4BedsBrokenMonthly;
  int? i4v4v4v4BedsLost;
  int? i4v4v4v4Deaths;
  int? i4v4v4v4FinalAssists;
  int? i4v4v4v4FinalDeaths;
  int? i4v4v4v4FinalKills;
  int? i4v4v4v4FinalKillsMonthly;
  int? i4v4v4v4GamesPlayed;
  int? i4v4v4v4Kills;
  int? i4v4v4v4KillsMonthly;
  int? i4v4v4v4MaxWinstreak;
  int? i4v4v4v4Wins;
  int? i4v4v4v4WinsMonthly;
  int? i4v4v4v4Winstreak;
  int? i4v4v4v4WinstreakMonthly;
  int? assists;
  int? bedsBroken;
  int? bedsBrokenMonthly;
  int? bedsBrokenWeekly;
  int? bedsLost;
  int? deaths;
  int? doublesAssists;
  int? doublesBedsBroken;
  int? doublesBedsBrokenMonthly;
  int? doublesBedsBrokenWeekly;
  int? doublesBedsLost;
  int? doublesDeaths;
  int? doublesFinalAssists;
  int? doublesFinalDeaths;
  int? doublesFinalKills;
  int? doublesFinalKillsMonthly;
  int? doublesFinalKillsWeekly;
  int? doublesGamesPlayed;
  int? doublesKills;
  int? doublesKillsMonthly;
  int? doublesKillsWeekly;
  int? doublesLosses;
  int? doublesMaxWinstreak;
  int? doublesWins;
  int? doublesWinsMonthly;
  int? doublesWinsWeekly;
  int? doublesWinstreak;
  int? doublesWinstreakMonthly;
  int? doublesWinstreakWeekly;
  int? finalAssists;
  int? finalDeaths;
  int? finalKills;
  int? finalKillsMonthly;
  int? finalKillsWeekly;
  int? gamesPlayed;
  int? kills;
  int? killsMonthly;
  int? killsWeekly;
  int? level;
  LevelBadge? levelBadge;
  int? levelMonthly;
  int? levelWeekly;
  int? losses;
  int? maxWinstreak;
  int? soloBedsBroken;
  int? soloBedsLost;
  int? soloDeaths;
  int? soloFinalDeaths;
  int? soloGamesPlayed;
  int? soloKills;
  int? soloLosses;
  int? soloWinstreak;
  int? wins;
  int? winsMonthly;
  int? winsWeekly;
  int? winstreak;
  int? winstreakMonthly;
  int? winstreakWeekly;
  int? xp;
  int? xpMonthly;
  int? xpWeekly;

  Bedwars(
      {this.i1v1GamesPlayed,
        this.i3v3v3v3Assists,
        this.i3v3v3v3BedsBroken,
        this.i3v3v3v3BedsBrokenMonthly,
        this.i3v3v3v3BedsLost,
        this.i3v3v3v3Deaths,
        this.i3v3v3v3FinalAssists,
        this.i3v3v3v3FinalDeaths,
        this.i3v3v3v3FinalKills,
        this.i3v3v3v3FinalKillsMonthly,
        this.i3v3v3v3GamesPlayed,
        this.i3v3v3v3Kills,
        this.i3v3v3v3KillsMonthly,
        this.i3v3v3v3Losses,
        this.i3v3v3v3MaxWinstreak,
        this.i3v3v3v3Wins,
        this.i3v3v3v3WinsMonthly,
        this.i3v3v3v3Winstreak,
        this.i4v4v4v4Assists,
        this.i4v4v4v4BedsBroken,
        this.i4v4v4v4BedsBrokenMonthly,
        this.i4v4v4v4BedsLost,
        this.i4v4v4v4Deaths,
        this.i4v4v4v4FinalAssists,
        this.i4v4v4v4FinalDeaths,
        this.i4v4v4v4FinalKills,
        this.i4v4v4v4FinalKillsMonthly,
        this.i4v4v4v4GamesPlayed,
        this.i4v4v4v4Kills,
        this.i4v4v4v4KillsMonthly,
        this.i4v4v4v4MaxWinstreak,
        this.i4v4v4v4Wins,
        this.i4v4v4v4WinsMonthly,
        this.i4v4v4v4Winstreak,
        this.i4v4v4v4WinstreakMonthly,
        this.assists,
        this.bedsBroken,
        this.bedsBrokenMonthly,
        this.bedsBrokenWeekly,
        this.bedsLost,
        this.deaths,
        this.doublesAssists,
        this.doublesBedsBroken,
        this.doublesBedsBrokenMonthly,
        this.doublesBedsBrokenWeekly,
        this.doublesBedsLost,
        this.doublesDeaths,
        this.doublesFinalAssists,
        this.doublesFinalDeaths,
        this.doublesFinalKills,
        this.doublesFinalKillsMonthly,
        this.doublesFinalKillsWeekly,
        this.doublesGamesPlayed,
        this.doublesKills,
        this.doublesKillsMonthly,
        this.doublesKillsWeekly,
        this.doublesLosses,
        this.doublesMaxWinstreak,
        this.doublesWins,
        this.doublesWinsMonthly,
        this.doublesWinsWeekly,
        this.doublesWinstreak,
        this.doublesWinstreakMonthly,
        this.doublesWinstreakWeekly,
        this.finalAssists,
        this.finalDeaths,
        this.finalKills,
        this.finalKillsMonthly,
        this.finalKillsWeekly,
        this.gamesPlayed,
        this.kills,
        this.killsMonthly,
        this.killsWeekly,
        this.level,
        this.levelBadge,
        this.levelMonthly,
        this.levelWeekly,
        this.losses,
        this.maxWinstreak,
        this.soloBedsBroken,
        this.soloBedsLost,
        this.soloDeaths,
        this.soloFinalDeaths,
        this.soloGamesPlayed,
        this.soloKills,
        this.soloLosses,
        this.soloWinstreak,
        this.wins,
        this.winsMonthly,
        this.winsWeekly,
        this.winstreak,
        this.winstreakMonthly,
        this.winstreakWeekly,
        this.xp,
        this.xpMonthly,
        this.xpWeekly});

  Bedwars.fromJson(Map<String, dynamic> json) {
    i1v1GamesPlayed = json['1v1_games_played'];
    i3v3v3v3Assists = json['3v3v3v3_assists'];
    i3v3v3v3BedsBroken = json['3v3v3v3_beds_broken'];
    i3v3v3v3BedsBrokenMonthly = json['3v3v3v3_beds_broken_monthly'];
    i3v3v3v3BedsLost = json['3v3v3v3_beds_lost'];
    i3v3v3v3Deaths = json['3v3v3v3_deaths'];
    i3v3v3v3FinalAssists = json['3v3v3v3_final_assists'];
    i3v3v3v3FinalDeaths = json['3v3v3v3_final_deaths'];
    i3v3v3v3FinalKills = json['3v3v3v3_final_kills'];
    i3v3v3v3FinalKillsMonthly = json['3v3v3v3_final_kills_monthly'];
    i3v3v3v3GamesPlayed = json['3v3v3v3_games_played'];
    i3v3v3v3Kills = json['3v3v3v3_kills'];
    i3v3v3v3KillsMonthly = json['3v3v3v3_kills_monthly'];
    i3v3v3v3Losses = json['3v3v3v3_losses'];
    i3v3v3v3MaxWinstreak = json['3v3v3v3_max_winstreak'];
    i3v3v3v3Wins = json['3v3v3v3_wins'];
    i3v3v3v3WinsMonthly = json['3v3v3v3_wins_monthly'];
    i3v3v3v3Winstreak = json['3v3v3v3_winstreak'];
    i4v4v4v4Assists = json['4v4v4v4_assists'];
    i4v4v4v4BedsBroken = json['4v4v4v4_beds_broken'];
    i4v4v4v4BedsBrokenMonthly = json['4v4v4v4_beds_broken_monthly'];
    i4v4v4v4BedsLost = json['4v4v4v4_beds_lost'];
    i4v4v4v4Deaths = json['4v4v4v4_deaths'];
    i4v4v4v4FinalAssists = json['4v4v4v4_final_assists'];
    i4v4v4v4FinalDeaths = json['4v4v4v4_final_deaths'];
    i4v4v4v4FinalKills = json['4v4v4v4_final_kills'];
    i4v4v4v4FinalKillsMonthly = json['4v4v4v4_final_kills_monthly'];
    i4v4v4v4GamesPlayed = json['4v4v4v4_games_played'];
    i4v4v4v4Kills = json['4v4v4v4_kills'];
    i4v4v4v4KillsMonthly = json['4v4v4v4_kills_monthly'];
    i4v4v4v4MaxWinstreak = json['4v4v4v4_max_winstreak'];
    i4v4v4v4Wins = json['4v4v4v4_wins'];
    i4v4v4v4WinsMonthly = json['4v4v4v4_wins_monthly'];
    i4v4v4v4Winstreak = json['4v4v4v4_winstreak'];
    i4v4v4v4WinstreakMonthly = json['4v4v4v4_winstreak_monthly'];
    assists = json['assists'];
    bedsBroken = json['beds_broken'];
    bedsBrokenMonthly = json['beds_broken_monthly'];
    bedsBrokenWeekly = json['beds_broken_weekly'];
    bedsLost = json['beds_lost'];
    deaths = json['deaths'];
    doublesAssists = json['doubles_assists'];
    doublesBedsBroken = json['doubles_beds_broken'];
    doublesBedsBrokenMonthly = json['doubles_beds_broken_monthly'];
    doublesBedsBrokenWeekly = json['doubles_beds_broken_weekly'];
    doublesBedsLost = json['doubles_beds_lost'];
    doublesDeaths = json['doubles_deaths'];
    doublesFinalAssists = json['doubles_final_assists'];
    doublesFinalDeaths = json['doubles_final_deaths'];
    doublesFinalKills = json['doubles_final_kills'];
    doublesFinalKillsMonthly = json['doubles_final_kills_monthly'];
    doublesFinalKillsWeekly = json['doubles_final_kills_weekly'];
    doublesGamesPlayed = json['doubles_games_played'];
    doublesKills = json['doubles_kills'];
    doublesKillsMonthly = json['doubles_kills_monthly'];
    doublesKillsWeekly = json['doubles_kills_weekly'];
    doublesLosses = json['doubles_losses'];
    doublesMaxWinstreak = json['doubles_max_winstreak'];
    doublesWins = json['doubles_wins'];
    doublesWinsMonthly = json['doubles_wins_monthly'];
    doublesWinsWeekly = json['doubles_wins_weekly'];
    doublesWinstreak = json['doubles_winstreak'];
    doublesWinstreakMonthly = json['doubles_winstreak_monthly'];
    doublesWinstreakWeekly = json['doubles_winstreak_weekly'];
    finalAssists = json['final_assists'];
    finalDeaths = json['final_deaths'];
    finalKills = json['final_kills'];
    finalKillsMonthly = json['final_kills_monthly'];
    finalKillsWeekly = json['final_kills_weekly'];
    gamesPlayed = json['games_played'];
    kills = json['kills'];
    killsMonthly = json['kills_monthly'];
    killsWeekly = json['kills_weekly'];
    level = json['level'];
    levelBadge = json['level_badge'] != null
        ? new LevelBadge.fromJson(json['level_badge'])
        : null;
    levelMonthly = json['level_monthly'];
    levelWeekly = json['level_weekly'];
    losses = json['losses'];
    maxWinstreak = json['max_winstreak'];
    soloBedsBroken = json['solo_beds_broken'];
    soloBedsLost = json['solo_beds_lost'];
    soloDeaths = json['solo_deaths'];
    soloFinalDeaths = json['solo_final_deaths'];
    soloGamesPlayed = json['solo_games_played'];
    soloKills = json['solo_kills'];
    soloLosses = json['solo_losses'];
    soloWinstreak = json['solo_winstreak'];
    wins = json['wins'];
    winsMonthly = json['wins_monthly'];
    winsWeekly = json['wins_weekly'];
    winstreak = json['winstreak'];
    winstreakMonthly = json['winstreak_monthly'];
    winstreakWeekly = json['winstreak_weekly'];
    xp = json['xp'];
    xpMonthly = json['xp_monthly'];
    xpWeekly = json['xp_weekly'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1v1_games_played'] = this.i1v1GamesPlayed;
    data['3v3v3v3_assists'] = this.i3v3v3v3Assists;
    data['3v3v3v3_beds_broken'] = this.i3v3v3v3BedsBroken;
    data['3v3v3v3_beds_broken_monthly'] = this.i3v3v3v3BedsBrokenMonthly;
    data['3v3v3v3_beds_lost'] = this.i3v3v3v3BedsLost;
    data['3v3v3v3_deaths'] = this.i3v3v3v3Deaths;
    data['3v3v3v3_final_assists'] = this.i3v3v3v3FinalAssists;
    data['3v3v3v3_final_deaths'] = this.i3v3v3v3FinalDeaths;
    data['3v3v3v3_final_kills'] = this.i3v3v3v3FinalKills;
    data['3v3v3v3_final_kills_monthly'] = this.i3v3v3v3FinalKillsMonthly;
    data['3v3v3v3_games_played'] = this.i3v3v3v3GamesPlayed;
    data['3v3v3v3_kills'] = this.i3v3v3v3Kills;
    data['3v3v3v3_kills_monthly'] = this.i3v3v3v3KillsMonthly;
    data['3v3v3v3_losses'] = this.i3v3v3v3Losses;
    data['3v3v3v3_max_winstreak'] = this.i3v3v3v3MaxWinstreak;
    data['3v3v3v3_wins'] = this.i3v3v3v3Wins;
    data['3v3v3v3_wins_monthly'] = this.i3v3v3v3WinsMonthly;
    data['3v3v3v3_winstreak'] = this.i3v3v3v3Winstreak;
    data['4v4v4v4_assists'] = this.i4v4v4v4Assists;
    data['4v4v4v4_beds_broken'] = this.i4v4v4v4BedsBroken;
    data['4v4v4v4_beds_broken_monthly'] = this.i4v4v4v4BedsBrokenMonthly;
    data['4v4v4v4_beds_lost'] = this.i4v4v4v4BedsLost;
    data['4v4v4v4_deaths'] = this.i4v4v4v4Deaths;
    data['4v4v4v4_final_assists'] = this.i4v4v4v4FinalAssists;
    data['4v4v4v4_final_deaths'] = this.i4v4v4v4FinalDeaths;
    data['4v4v4v4_final_kills'] = this.i4v4v4v4FinalKills;
    data['4v4v4v4_final_kills_monthly'] = this.i4v4v4v4FinalKillsMonthly;
    data['4v4v4v4_games_played'] = this.i4v4v4v4GamesPlayed;
    data['4v4v4v4_kills'] = this.i4v4v4v4Kills;
    data['4v4v4v4_kills_monthly'] = this.i4v4v4v4KillsMonthly;
    data['4v4v4v4_max_winstreak'] = this.i4v4v4v4MaxWinstreak;
    data['4v4v4v4_wins'] = this.i4v4v4v4Wins;
    data['4v4v4v4_wins_monthly'] = this.i4v4v4v4WinsMonthly;
    data['4v4v4v4_winstreak'] = this.i4v4v4v4Winstreak;
    data['4v4v4v4_winstreak_monthly'] = this.i4v4v4v4WinstreakMonthly;
    data['assists'] = this.assists;
    data['beds_broken'] = this.bedsBroken;
    data['beds_broken_monthly'] = this.bedsBrokenMonthly;
    data['beds_broken_weekly'] = this.bedsBrokenWeekly;
    data['beds_lost'] = this.bedsLost;
    data['deaths'] = this.deaths;
    data['doubles_assists'] = this.doublesAssists;
    data['doubles_beds_broken'] = this.doublesBedsBroken;
    data['doubles_beds_broken_monthly'] = this.doublesBedsBrokenMonthly;
    data['doubles_beds_broken_weekly'] = this.doublesBedsBrokenWeekly;
    data['doubles_beds_lost'] = this.doublesBedsLost;
    data['doubles_deaths'] = this.doublesDeaths;
    data['doubles_final_assists'] = this.doublesFinalAssists;
    data['doubles_final_deaths'] = this.doublesFinalDeaths;
    data['doubles_final_kills'] = this.doublesFinalKills;
    data['doubles_final_kills_monthly'] = this.doublesFinalKillsMonthly;
    data['doubles_final_kills_weekly'] = this.doublesFinalKillsWeekly;
    data['doubles_games_played'] = this.doublesGamesPlayed;
    data['doubles_kills'] = this.doublesKills;
    data['doubles_kills_monthly'] = this.doublesKillsMonthly;
    data['doubles_kills_weekly'] = this.doublesKillsWeekly;
    data['doubles_losses'] = this.doublesLosses;
    data['doubles_max_winstreak'] = this.doublesMaxWinstreak;
    data['doubles_wins'] = this.doublesWins;
    data['doubles_wins_monthly'] = this.doublesWinsMonthly;
    data['doubles_wins_weekly'] = this.doublesWinsWeekly;
    data['doubles_winstreak'] = this.doublesWinstreak;
    data['doubles_winstreak_monthly'] = this.doublesWinstreakMonthly;
    data['doubles_winstreak_weekly'] = this.doublesWinstreakWeekly;
    data['final_assists'] = this.finalAssists;
    data['final_deaths'] = this.finalDeaths;
    data['final_kills'] = this.finalKills;
    data['final_kills_monthly'] = this.finalKillsMonthly;
    data['final_kills_weekly'] = this.finalKillsWeekly;
    data['games_played'] = this.gamesPlayed;
    data['kills'] = this.kills;
    data['kills_monthly'] = this.killsMonthly;
    data['kills_weekly'] = this.killsWeekly;
    data['level'] = this.level;
    if (this.levelBadge != null) {
      data['level_badge'] = this.levelBadge!.toJson();
    }
    data['level_monthly'] = this.levelMonthly;
    data['level_weekly'] = this.levelWeekly;
    data['losses'] = this.losses;
    data['max_winstreak'] = this.maxWinstreak;
    data['solo_beds_broken'] = this.soloBedsBroken;
    data['solo_beds_lost'] = this.soloBedsLost;
    data['solo_deaths'] = this.soloDeaths;
    data['solo_final_deaths'] = this.soloFinalDeaths;
    data['solo_games_played'] = this.soloGamesPlayed;
    data['solo_kills'] = this.soloKills;
    data['solo_losses'] = this.soloLosses;
    data['solo_winstreak'] = this.soloWinstreak;
    data['wins'] = this.wins;
    data['wins_monthly'] = this.winsMonthly;
    data['wins_weekly'] = this.winsWeekly;
    data['winstreak'] = this.winstreak;
    data['winstreak_monthly'] = this.winstreakMonthly;
    data['winstreak_weekly'] = this.winstreakWeekly;
    data['xp'] = this.xp;
    data['xp_monthly'] = this.xpMonthly;
    data['xp_weekly'] = this.xpWeekly;
    return data;
  }
}

class LevelBadge {
  String? format;
  String? hexColor;
  int? minLevel;
  String? symbol;
  String? type;

  LevelBadge(
      {this.format, this.hexColor, this.minLevel, this.symbol, this.type});

  LevelBadge.fromJson(Map<String, dynamic> json) {
    format = json['format'];
    hexColor = json['hex_color'];
    minLevel = json['min_level'];
    symbol = json['symbol'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['format'] = this.format;
    data['hex_color'] = this.hexColor;
    data['min_level'] = this.minLevel;
    data['symbol'] = this.symbol;
    data['type'] = this.type;
    return data;
  }
}

class Blockparty {
  int? played;
  int? rounds;

  Blockparty({this.played, this.rounds});

  Blockparty.fromJson(Map<String, dynamic> json) {
    played = json['played'];
    rounds = json['rounds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['played'] = this.played;
    data['rounds'] = this.rounds;
    return data;
  }
}

class Bridgepractice {
  int? diagonalShortBridgeAttempts;
  int? extraShortBestTime;
  int? extraShortBridgeAttempts;
  int? extraShortBridges;
  int? extraShortTotalTime;

  Bridgepractice(
      {this.diagonalShortBridgeAttempts,
        this.extraShortBestTime,
        this.extraShortBridgeAttempts,
        this.extraShortBridges,
        this.extraShortTotalTime});

  Bridgepractice.fromJson(Map<String, dynamic> json) {
    diagonalShortBridgeAttempts = json['diagonal_short_bridge_attempts'];
    extraShortBestTime = json['extra_short_best_time'];
    extraShortBridgeAttempts = json['extra_short_bridge_attempts'];
    extraShortBridges = json['extra_short_bridges'];
    extraShortTotalTime = json['extra_short_total_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diagonal_short_bridge_attempts'] = this.diagonalShortBridgeAttempts;
    data['extra_short_best_time'] = this.extraShortBestTime;
    data['extra_short_bridge_attempts'] = this.extraShortBridgeAttempts;
    data['extra_short_bridges'] = this.extraShortBridges;
    data['extra_short_total_time'] = this.extraShortTotalTime;
    return data;
  }
}

class Duels {
  int? boxingDeaths;
  int? boxingLosses;
  int? boxingPlayed;
  int? boxingSoloDeaths;
  int? boxingSoloLosses;
  int? boxingSoloPlayed;
  int? bridgeDeaths;
  int? bridgeDoublesDeaths;
  int? bridgeDoublesKills;
  int? bridgeDoublesKillsMonthly;
  int? bridgeDoublesLosses;
  int? bridgeDoublesMaxWinstreak;
  int? bridgeDoublesPlayed;
  int? bridgeDoublesWins;
  int? bridgeDoublesWinsMonthly;
  int? bridgeDoublesWinstreak;
  int? bridgeDoublesWinstreakMonthly;
  int? bridgeKills;
  int? bridgeKillsMonthly;
  int? bridgeLosses;
  int? bridgeMaxWinstreak;
  int? bridgePlayed;
  int? bridgeWins;
  int? bridgeWinsMonthly;
  int? bridgeWinstreak;
  int? bridgeWinstreakMonthly;
  int? comboKills;
  int? comboPlayed;
  int? comboSoloKills;
  int? comboSoloPlayed;
  int? comboSoloWins;
  int? comboSoloWinstreak;
  int? comboWins;
  int? comboWinstreak;
  int? gappleDeaths;
  int? gappleKills;
  int? gappleLosses;
  int? gapplePlayed;
  int? gappleSoloDeaths;
  int? gappleSoloKills;
  int? gappleSoloLosses;
  int? gappleSoloPlayed;
  int? gappleSoloWins;
  int? gappleSoloWinstreak;
  int? gappleWins;
  int? gappleWinstreak;
  int? gladiatorDoublesKills;
  int? gladiatorDoublesPlayed;
  int? gladiatorDoublesWins;
  int? gladiatorDoublesWinstreak;
  int? gladiatorKills;
  int? gladiatorPlayed;
  int? gladiatorWins;
  int? gladiatorWinstreak;

  Duels(
      {this.boxingDeaths,
        this.boxingLosses,
        this.boxingPlayed,
        this.boxingSoloDeaths,
        this.boxingSoloLosses,
        this.boxingSoloPlayed,
        this.bridgeDeaths,
        this.bridgeDoublesDeaths,
        this.bridgeDoublesKills,
        this.bridgeDoublesKillsMonthly,
        this.bridgeDoublesLosses,
        this.bridgeDoublesMaxWinstreak,
        this.bridgeDoublesPlayed,
        this.bridgeDoublesWins,
        this.bridgeDoublesWinsMonthly,
        this.bridgeDoublesWinstreak,
        this.bridgeDoublesWinstreakMonthly,
        this.bridgeKills,
        this.bridgeKillsMonthly,
        this.bridgeLosses,
        this.bridgeMaxWinstreak,
        this.bridgePlayed,
        this.bridgeWins,
        this.bridgeWinsMonthly,
        this.bridgeWinstreak,
        this.bridgeWinstreakMonthly,
        this.comboKills,
        this.comboPlayed,
        this.comboSoloKills,
        this.comboSoloPlayed,
        this.comboSoloWins,
        this.comboSoloWinstreak,
        this.comboWins,
        this.comboWinstreak,
        this.gappleDeaths,
        this.gappleKills,
        this.gappleLosses,
        this.gapplePlayed,
        this.gappleSoloDeaths,
        this.gappleSoloKills,
        this.gappleSoloLosses,
        this.gappleSoloPlayed,
        this.gappleSoloWins,
        this.gappleSoloWinstreak,
        this.gappleWins,
        this.gappleWinstreak,
        this.gladiatorDoublesKills,
        this.gladiatorDoublesPlayed,
        this.gladiatorDoublesWins,
        this.gladiatorDoublesWinstreak,
        this.gladiatorKills,
        this.gladiatorPlayed,
        this.gladiatorWins,
        this.gladiatorWinstreak});

  Duels.fromJson(Map<String, dynamic> json) {
    boxingDeaths = json['boxing_deaths'];
    boxingLosses = json['boxing_losses'];
    boxingPlayed = json['boxing_played'];
    boxingSoloDeaths = json['boxing_solo_deaths'];
    boxingSoloLosses = json['boxing_solo_losses'];
    boxingSoloPlayed = json['boxing_solo_played'];
    bridgeDeaths = json['bridge_deaths'];
    bridgeDoublesDeaths = json['bridge_doubles_deaths'];
    bridgeDoublesKills = json['bridge_doubles_kills'];
    bridgeDoublesKillsMonthly = json['bridge_doubles_kills_monthly'];
    bridgeDoublesLosses = json['bridge_doubles_losses'];
    bridgeDoublesMaxWinstreak = json['bridge_doubles_max_winstreak'];
    bridgeDoublesPlayed = json['bridge_doubles_played'];
    bridgeDoublesWins = json['bridge_doubles_wins'];
    bridgeDoublesWinsMonthly = json['bridge_doubles_wins_monthly'];
    bridgeDoublesWinstreak = json['bridge_doubles_winstreak'];
    bridgeDoublesWinstreakMonthly = json['bridge_doubles_winstreak_monthly'];
    bridgeKills = json['bridge_kills'];
    bridgeKillsMonthly = json['bridge_kills_monthly'];
    bridgeLosses = json['bridge_losses'];
    bridgeMaxWinstreak = json['bridge_max_winstreak'];
    bridgePlayed = json['bridge_played'];
    bridgeWins = json['bridge_wins'];
    bridgeWinsMonthly = json['bridge_wins_monthly'];
    bridgeWinstreak = json['bridge_winstreak'];
    bridgeWinstreakMonthly = json['bridge_winstreak_monthly'];
    comboKills = json['combo_kills'];
    comboPlayed = json['combo_played'];
    comboSoloKills = json['combo_solo_kills'];
    comboSoloPlayed = json['combo_solo_played'];
    comboSoloWins = json['combo_solo_wins'];
    comboSoloWinstreak = json['combo_solo_winstreak'];
    comboWins = json['combo_wins'];
    comboWinstreak = json['combo_winstreak'];
    gappleDeaths = json['gapple_deaths'];
    gappleKills = json['gapple_kills'];
    gappleLosses = json['gapple_losses'];
    gapplePlayed = json['gapple_played'];
    gappleSoloDeaths = json['gapple_solo_deaths'];
    gappleSoloKills = json['gapple_solo_kills'];
    gappleSoloLosses = json['gapple_solo_losses'];
    gappleSoloPlayed = json['gapple_solo_played'];
    gappleSoloWins = json['gapple_solo_wins'];
    gappleSoloWinstreak = json['gapple_solo_winstreak'];
    gappleWins = json['gapple_wins'];
    gappleWinstreak = json['gapple_winstreak'];
    gladiatorDoublesKills = json['gladiator_doubles_kills'];
    gladiatorDoublesPlayed = json['gladiator_doubles_played'];
    gladiatorDoublesWins = json['gladiator_doubles_wins'];
    gladiatorDoublesWinstreak = json['gladiator_doubles_winstreak'];
    gladiatorKills = json['gladiator_kills'];
    gladiatorPlayed = json['gladiator_played'];
    gladiatorWins = json['gladiator_wins'];
    gladiatorWinstreak = json['gladiator_winstreak'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boxing_deaths'] = this.boxingDeaths;
    data['boxing_losses'] = this.boxingLosses;
    data['boxing_played'] = this.boxingPlayed;
    data['boxing_solo_deaths'] = this.boxingSoloDeaths;
    data['boxing_solo_losses'] = this.boxingSoloLosses;
    data['boxing_solo_played'] = this.boxingSoloPlayed;
    data['bridge_deaths'] = this.bridgeDeaths;
    data['bridge_doubles_deaths'] = this.bridgeDoublesDeaths;
    data['bridge_doubles_kills'] = this.bridgeDoublesKills;
    data['bridge_doubles_kills_monthly'] = this.bridgeDoublesKillsMonthly;
    data['bridge_doubles_losses'] = this.bridgeDoublesLosses;
    data['bridge_doubles_max_winstreak'] = this.bridgeDoublesMaxWinstreak;
    data['bridge_doubles_played'] = this.bridgeDoublesPlayed;
    data['bridge_doubles_wins'] = this.bridgeDoublesWins;
    data['bridge_doubles_wins_monthly'] = this.bridgeDoublesWinsMonthly;
    data['bridge_doubles_winstreak'] = this.bridgeDoublesWinstreak;
    data['bridge_doubles_winstreak_monthly'] =
        this.bridgeDoublesWinstreakMonthly;
    data['bridge_kills'] = this.bridgeKills;
    data['bridge_kills_monthly'] = this.bridgeKillsMonthly;
    data['bridge_losses'] = this.bridgeLosses;
    data['bridge_max_winstreak'] = this.bridgeMaxWinstreak;
    data['bridge_played'] = this.bridgePlayed;
    data['bridge_wins'] = this.bridgeWins;
    data['bridge_wins_monthly'] = this.bridgeWinsMonthly;
    data['bridge_winstreak'] = this.bridgeWinstreak;
    data['bridge_winstreak_monthly'] = this.bridgeWinstreakMonthly;
    data['combo_kills'] = this.comboKills;
    data['combo_played'] = this.comboPlayed;
    data['combo_solo_kills'] = this.comboSoloKills;
    data['combo_solo_played'] = this.comboSoloPlayed;
    data['combo_solo_wins'] = this.comboSoloWins;
    data['combo_solo_winstreak'] = this.comboSoloWinstreak;
    data['combo_wins'] = this.comboWins;
    data['combo_winstreak'] = this.comboWinstreak;
    data['gapple_deaths'] = this.gappleDeaths;
    data['gapple_kills'] = this.gappleKills;
    data['gapple_losses'] = this.gappleLosses;
    data['gapple_played'] = this.gapplePlayed;
    data['gapple_solo_deaths'] = this.gappleSoloDeaths;
    data['gapple_solo_kills'] = this.gappleSoloKills;
    data['gapple_solo_losses'] = this.gappleSoloLosses;
    data['gapple_solo_played'] = this.gappleSoloPlayed;
    data['gapple_solo_wins'] = this.gappleSoloWins;
    data['gapple_solo_winstreak'] = this.gappleSoloWinstreak;
    data['gapple_wins'] = this.gappleWins;
    data['gapple_winstreak'] = this.gappleWinstreak;
    data['gladiator_doubles_kills'] = this.gladiatorDoublesKills;
    data['gladiator_doubles_played'] = this.gladiatorDoublesPlayed;
    data['gladiator_doubles_wins'] = this.gladiatorDoublesWins;
    data['gladiator_doubles_winstreak'] = this.gladiatorDoublesWinstreak;
    data['gladiator_kills'] = this.gladiatorKills;
    data['gladiator_played'] = this.gladiatorPlayed;
    data['gladiator_wins'] = this.gladiatorWins;
    data['gladiator_winstreak'] = this.gladiatorWinstreak;
    return data;
  }
}

class Hungergames {
  DoublekitRanking? doublekitRanking;
  DoublekitRanking? minimushRanking;

  Hungergames({this.doublekitRanking, this.minimushRanking});

  Hungergames.fromJson(Map<String, dynamic> json) {
    doublekitRanking = json['doublekit_ranking'] != null
        ? new DoublekitRanking.fromJson(json['doublekit_ranking'])
        : null;
    minimushRanking = json['minimush_ranking'] != null
        ? new DoublekitRanking.fromJson(json['minimush_ranking'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doublekitRanking != null) {
      data['doublekit_ranking'] = this.doublekitRanking!.toJson();
    }
    if (this.minimushRanking != null) {
      data['minimush_ranking'] = this.minimushRanking!.toJson();
    }
    return data;
  }
}

class DoublekitRanking {
  String? hexColor;
  String? id;
  String? name;
  String? symbol;

  DoublekitRanking({this.hexColor, this.id, this.name, this.symbol});

  DoublekitRanking.fromJson(Map<String, dynamic> json) {
    hexColor = json['hex_color'];
    id = json['id'];
    name = json['name'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hex_color'] = this.hexColor;
    data['id'] = this.id;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    return data;
  }
}

class Murder {
  int? coinsPickedUp;
  int? deaths;
  int? detectiveDeaths;
  int? detectiveLosses;
  int? detectivePlayed;
  int? detectiveWinstreak;
  int? innocentDeaths;
  int? innocentKilledMurderer;
  int? innocentKills;
  int? innocentLosses;
  int? innocentPlayed;
  int? innocentWins;
  int? innocentWinstreak;
  int? killedMurderer;
  int? kills;
  int? losses;
  int? murdererDeaths;
  int? murdererKills;
  int? murdererLosses;
  int? murdererPlayed;
  int? murdererWinstreak;
  int? played;
  int? wins;
  int? winstreak;

  Murder(
      {this.coinsPickedUp,
        this.deaths,
        this.detectiveDeaths,
        this.detectiveLosses,
        this.detectivePlayed,
        this.detectiveWinstreak,
        this.innocentDeaths,
        this.innocentKilledMurderer,
        this.innocentKills,
        this.innocentLosses,
        this.innocentPlayed,
        this.innocentWins,
        this.innocentWinstreak,
        this.killedMurderer,
        this.kills,
        this.losses,
        this.murdererDeaths,
        this.murdererKills,
        this.murdererLosses,
        this.murdererPlayed,
        this.murdererWinstreak,
        this.played,
        this.wins,
        this.winstreak});

  Murder.fromJson(Map<String, dynamic> json) {
    coinsPickedUp = json['coins_picked_up'];
    deaths = json['deaths'];
    detectiveDeaths = json['detective_deaths'];
    detectiveLosses = json['detective_losses'];
    detectivePlayed = json['detective_played'];
    detectiveWinstreak = json['detective_winstreak'];
    innocentDeaths = json['innocent_deaths'];
    innocentKilledMurderer = json['innocent_killed_murderer'];
    innocentKills = json['innocent_kills'];
    innocentLosses = json['innocent_losses'];
    innocentPlayed = json['innocent_played'];
    innocentWins = json['innocent_wins'];
    innocentWinstreak = json['innocent_winstreak'];
    killedMurderer = json['killed_murderer'];
    kills = json['kills'];
    losses = json['losses'];
    murdererDeaths = json['murderer_deaths'];
    murdererKills = json['murderer_kills'];
    murdererLosses = json['murderer_losses'];
    murdererPlayed = json['murderer_played'];
    murdererWinstreak = json['murderer_winstreak'];
    played = json['played'];
    wins = json['wins'];
    winstreak = json['winstreak'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coins_picked_up'] = this.coinsPickedUp;
    data['deaths'] = this.deaths;
    data['detective_deaths'] = this.detectiveDeaths;
    data['detective_losses'] = this.detectiveLosses;
    data['detective_played'] = this.detectivePlayed;
    data['detective_winstreak'] = this.detectiveWinstreak;
    data['innocent_deaths'] = this.innocentDeaths;
    data['innocent_killed_murderer'] = this.innocentKilledMurderer;
    data['innocent_kills'] = this.innocentKills;
    data['innocent_losses'] = this.innocentLosses;
    data['innocent_played'] = this.innocentPlayed;
    data['innocent_wins'] = this.innocentWins;
    data['innocent_winstreak'] = this.innocentWinstreak;
    data['killed_murderer'] = this.killedMurderer;
    data['kills'] = this.kills;
    data['losses'] = this.losses;
    data['murderer_deaths'] = this.murdererDeaths;
    data['murderer_kills'] = this.murdererKills;
    data['murderer_losses'] = this.murdererLosses;
    data['murderer_played'] = this.murdererPlayed;
    data['murderer_winstreak'] = this.murdererWinstreak;
    data['played'] = this.played;
    data['wins'] = this.wins;
    data['winstreak'] = this.winstreak;
    return data;
  }
}

class PlayTime {
  int? all;
  int? bedwars;
  int? bedwars1v1;
  int? bedwars2v2;
  int? bedwars3v3v3v3;
  int? bedwars4v4v4v4;
  int? bedwarsDoubles;
  int? bedwarsMega;
  int? bedwarsSolo;
  int? bridgepractice;
  int? bridgepracticeDiagonalShort;
  int? bridgepracticeExtraShort;
  int? bridgepracticeInfinite;
  int? duels;
  int? duelsBoxing;
  int? duelsBoxingSolo;
  int? duelsBridge;
  int? duelsBridgeDoubles;
  int? duelsBridgeSolo;
  int? duelsCombo;
  int? duelsComboSolo;
  int? duelsGapple;
  int? duelsGappleSolo;
  int? duelsGladiator;
  int? duelsGladiatorDoubles;
  int? duelsGladiatorSolo;
  int? duelsSumo;
  int? duelsSumoSolo;
  int? hungergames;
  int? hungergamesHg;
  int? lobby;
  int? lobbyBedwars;
  int? lobbyDuels;
  int? lobbyDuelsGladiator;
  int? lobbyDuelsSoup;
  int? lobbyHungergames;
  int? lobbyMain;
  int? lobbyPvp;
  int? lobbySkywars;
  int? pvp;
  int? pvpArena;
  int? pvpChallenges;
  int? pvpFps;
  int? pvpLava;
  int? quickbuilders;
  int? skywars;
  int? skywarsTeam;

  PlayTime(
      {this.all,
        this.bedwars,
        this.bedwars1v1,
        this.bedwars2v2,
        this.bedwars3v3v3v3,
        this.bedwars4v4v4v4,
        this.bedwarsDoubles,
        this.bedwarsMega,
        this.bedwarsSolo,
        this.bridgepractice,
        this.bridgepracticeDiagonalShort,
        this.bridgepracticeExtraShort,
        this.bridgepracticeInfinite,
        this.duels,
        this.duelsBoxing,
        this.duelsBoxingSolo,
        this.duelsBridge,
        this.duelsBridgeDoubles,
        this.duelsBridgeSolo,
        this.duelsCombo,
        this.duelsComboSolo,
        this.duelsGapple,
        this.duelsGappleSolo,
        this.duelsGladiator,
        this.duelsGladiatorDoubles,
        this.duelsGladiatorSolo,
        this.duelsSumo,
        this.duelsSumoSolo,
        this.hungergames,
        this.hungergamesHg,
        this.lobby,
        this.lobbyBedwars,
        this.lobbyDuels,
        this.lobbyDuelsGladiator,
        this.lobbyDuelsSoup,
        this.lobbyHungergames,
        this.lobbyMain,
        this.lobbyPvp,
        this.lobbySkywars,
        this.pvp,
        this.pvpArena,
        this.pvpChallenges,
        this.pvpFps,
        this.pvpLava,
        this.quickbuilders,
        this.skywars,
        this.skywarsTeam});

  PlayTime.fromJson(Map<String, dynamic> json) {
    all = json['all'];
    bedwars = json['bedwars'];
    bedwars1v1 = json['bedwars_1v1'];
    bedwars2v2 = json['bedwars_2v2'];
    bedwars3v3v3v3 = json['bedwars_3v3v3v3'];
    bedwars4v4v4v4 = json['bedwars_4v4v4v4'];
    bedwarsDoubles = json['bedwars_doubles'];
    bedwarsMega = json['bedwars_mega'];
    bedwarsSolo = json['bedwars_solo'];
    bridgepractice = json['bridgepractice'];
    bridgepracticeDiagonalShort = json['bridgepractice_diagonal_short'];
    bridgepracticeExtraShort = json['bridgepractice_extra_short'];
    bridgepracticeInfinite = json['bridgepractice_infinite'];
    duels = json['duels'];
    duelsBoxing = json['duels_boxing'];
    duelsBoxingSolo = json['duels_boxing_solo'];
    duelsBridge = json['duels_bridge'];
    duelsBridgeDoubles = json['duels_bridge_doubles'];
    duelsBridgeSolo = json['duels_bridge_solo'];
    duelsCombo = json['duels_combo'];
    duelsComboSolo = json['duels_combo_solo'];
    duelsGapple = json['duels_gapple'];
    duelsGappleSolo = json['duels_gapple_solo'];
    duelsGladiator = json['duels_gladiator'];
    duelsGladiatorDoubles = json['duels_gladiator_doubles'];
    duelsGladiatorSolo = json['duels_gladiator_solo'];
    duelsSumo = json['duels_sumo'];
    duelsSumoSolo = json['duels_sumo_solo'];
    hungergames = json['hungergames'];
    hungergamesHg = json['hungergames_hg'];
    lobby = json['lobby'];
    lobbyBedwars = json['lobby_bedwars'];
    lobbyDuels = json['lobby_duels'];
    lobbyDuelsGladiator = json['lobby_duels_gladiator'];
    lobbyDuelsSoup = json['lobby_duels_soup'];
    lobbyHungergames = json['lobby_hungergames'];
    lobbyMain = json['lobby_main'];
    lobbyPvp = json['lobby_pvp'];
    lobbySkywars = json['lobby_skywars'];
    pvp = json['pvp'];
    pvpArena = json['pvp_arena'];
    pvpChallenges = json['pvp_challenges'];
    pvpFps = json['pvp_fps'];
    pvpLava = json['pvp_lava'];
    quickbuilders = json['quickbuilders'];
    skywars = json['skywars'];
    skywarsTeam = json['skywars_team'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all'] = this.all;
    data['bedwars'] = this.bedwars;
    data['bedwars_1v1'] = this.bedwars1v1;
    data['bedwars_2v2'] = this.bedwars2v2;
    data['bedwars_3v3v3v3'] = this.bedwars3v3v3v3;
    data['bedwars_4v4v4v4'] = this.bedwars4v4v4v4;
    data['bedwars_doubles'] = this.bedwarsDoubles;
    data['bedwars_mega'] = this.bedwarsMega;
    data['bedwars_solo'] = this.bedwarsSolo;
    data['bridgepractice'] = this.bridgepractice;
    data['bridgepractice_diagonal_short'] = this.bridgepracticeDiagonalShort;
    data['bridgepractice_extra_short'] = this.bridgepracticeExtraShort;
    data['bridgepractice_infinite'] = this.bridgepracticeInfinite;
    data['duels'] = this.duels;
    data['duels_boxing'] = this.duelsBoxing;
    data['duels_boxing_solo'] = this.duelsBoxingSolo;
    data['duels_bridge'] = this.duelsBridge;
    data['duels_bridge_doubles'] = this.duelsBridgeDoubles;
    data['duels_bridge_solo'] = this.duelsBridgeSolo;
    data['duels_combo'] = this.duelsCombo;
    data['duels_combo_solo'] = this.duelsComboSolo;
    data['duels_gapple'] = this.duelsGapple;
    data['duels_gapple_solo'] = this.duelsGappleSolo;
    data['duels_gladiator'] = this.duelsGladiator;
    data['duels_gladiator_doubles'] = this.duelsGladiatorDoubles;
    data['duels_gladiator_solo'] = this.duelsGladiatorSolo;
    data['duels_sumo'] = this.duelsSumo;
    data['duels_sumo_solo'] = this.duelsSumoSolo;
    data['hungergames'] = this.hungergames;
    data['hungergames_hg'] = this.hungergamesHg;
    data['lobby'] = this.lobby;
    data['lobby_bedwars'] = this.lobbyBedwars;
    data['lobby_duels'] = this.lobbyDuels;
    data['lobby_duels_gladiator'] = this.lobbyDuelsGladiator;
    data['lobby_duels_soup'] = this.lobbyDuelsSoup;
    data['lobby_hungergames'] = this.lobbyHungergames;
    data['lobby_main'] = this.lobbyMain;
    data['lobby_pvp'] = this.lobbyPvp;
    data['lobby_skywars'] = this.lobbySkywars;
    data['pvp'] = this.pvp;
    data['pvp_arena'] = this.pvpArena;
    data['pvp_challenges'] = this.pvpChallenges;
    data['pvp_fps'] = this.pvpFps;
    data['pvp_lava'] = this.pvpLava;
    data['quickbuilders'] = this.quickbuilders;
    data['skywars'] = this.skywars;
    data['skywars_team'] = this.skywarsTeam;
    return data;
  }
}

class Pvp {
  int? fpsDeaths;
  int? fpsKillstreak;

  Pvp({this.fpsDeaths, this.fpsKillstreak});

  Pvp.fromJson(Map<String, dynamic> json) {
    fpsDeaths = json['fps_deaths'];
    fpsKillstreak = json['fps_killstreak'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fps_deaths'] = this.fpsDeaths;
    data['fps_killstreak'] = this.fpsKillstreak;
    return data;
  }
}

class Quickbuilders {
  int? builds;
  int? losses;
  int? perfectBuildStreak;
  int? played;
  int? winstreak;

  Quickbuilders(
      {this.builds,
        this.losses,
        this.perfectBuildStreak,
        this.played,
        this.winstreak});

  Quickbuilders.fromJson(Map<String, dynamic> json) {
    builds = json['builds'];
    losses = json['losses'];
    perfectBuildStreak = json['perfect_build_streak'];
    played = json['played'];
    winstreak = json['winstreak'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['builds'] = this.builds;
    data['losses'] = this.losses;
    data['perfect_build_streak'] = this.perfectBuildStreak;
    data['played'] = this.played;
    data['winstreak'] = this.winstreak;
    return data;
  }
}

class SkywarsR1 {
  int? coins;
  int? deaths;
  int? deathsNormal;
  int? deathsNormalKitDefault;
  int? deathsTeam;
  int? deathsTeamKitDefault;
  int? gamesPlayed;
  int? gamesPlayedNormal;
  int? gamesPlayedNormalKitDefault;
  int? gamesPlayedTeam;
  int? gamesPlayedTeamKitDefault;
  LevelBadge? levelBadge;
  int? losses;
  int? lossesNormal;
  int? lossesNormalKitDefault;
  int? lossesTeam;
  int? lossesTeamKitDefault;
  int? selectedCage;
  int? winstreakTeam;

  SkywarsR1(
      {this.coins,
        this.deaths,
        this.deathsNormal,
        this.deathsNormalKitDefault,
        this.deathsTeam,
        this.deathsTeamKitDefault,
        this.gamesPlayed,
        this.gamesPlayedNormal,
        this.gamesPlayedNormalKitDefault,
        this.gamesPlayedTeam,
        this.gamesPlayedTeamKitDefault,
        this.levelBadge,
        this.losses,
        this.lossesNormal,
        this.lossesNormalKitDefault,
        this.lossesTeam,
        this.lossesTeamKitDefault,
        this.selectedCage,
        this.winstreakTeam});

  SkywarsR1.fromJson(Map<String, dynamic> json) {
    coins = json['coins'];
    deaths = json['deaths'];
    deathsNormal = json['deaths_normal'];
    deathsNormalKitDefault = json['deaths_normal_kit_default'];
    deathsTeam = json['deaths_team'];
    deathsTeamKitDefault = json['deaths_team_kit_default'];
    gamesPlayed = json['games_played'];
    gamesPlayedNormal = json['games_played_normal'];
    gamesPlayedNormalKitDefault = json['games_played_normal_kit_default'];
    gamesPlayedTeam = json['games_played_team'];
    gamesPlayedTeamKitDefault = json['games_played_team_kit_default'];
    levelBadge = json['level_badge'] != null
        ? new LevelBadge.fromJson(json['level_badge'])
        : null;
    losses = json['losses'];
    lossesNormal = json['losses_normal'];
    lossesNormalKitDefault = json['losses_normal_kit_default'];
    lossesTeam = json['losses_team'];
    lossesTeamKitDefault = json['losses_team_kit_default'];
    selectedCage = json['selected_cage'];
    winstreakTeam = json['winstreak_team'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coins'] = this.coins;
    data['deaths'] = this.deaths;
    data['deaths_normal'] = this.deathsNormal;
    data['deaths_normal_kit_default'] = this.deathsNormalKitDefault;
    data['deaths_team'] = this.deathsTeam;
    data['deaths_team_kit_default'] = this.deathsTeamKitDefault;
    data['games_played'] = this.gamesPlayed;
    data['games_played_normal'] = this.gamesPlayedNormal;
    data['games_played_normal_kit_default'] = this.gamesPlayedNormalKitDefault;
    data['games_played_team'] = this.gamesPlayedTeam;
    data['games_played_team_kit_default'] = this.gamesPlayedTeamKitDefault;
    if (this.levelBadge != null) {
      data['level_badge'] = this.levelBadge!.toJson();
    }
    data['losses'] = this.losses;
    data['losses_normal'] = this.lossesNormal;
    data['losses_normal_kit_default'] = this.lossesNormalKitDefault;
    data['losses_team'] = this.lossesTeam;
    data['losses_team_kit_default'] = this.lossesTeamKitDefault;
    data['selected_cage'] = this.selectedCage;
    data['winstreak_team'] = this.winstreakTeam;
    return data;
  }
}


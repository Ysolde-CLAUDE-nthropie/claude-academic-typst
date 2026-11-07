// Smoke test: Chinese text. Needs a CJK font, e.g. --font-path /path/to/noto-cjk.
#import "../claude-academic/lib.typ": *
#show: report.with(
  title: [分布偏移下语言模型的置信度校准],
  subtitle: [温度缩放的作用与局限],
  authors: ((name: "林晓", affiliation: "某某大学统计系", email: "lin@example.edu"), (name: "Ada Whitfield", affiliation: "Institute for Careful Machines")),
  date: datetime(year: 2026, month: 11, day: 7),
  abstract: [当模型报告的置信度与其正确的频率一致时，我们称模型是*校准*的。本文研究温度缩放（temperature scaling）在分布偏移下的表现。],
  keywords: ("校准", "分布偏移"),
  lang: "zh",
  fallback-fonts: ("Noto Serif SC",),
  toc: true,
)
= 引言 <sec-intro>
概率预测的价值取决于它是否诚实。如果天气预报说有 70% 的概率下雨，那么在这样的日子里大约十天中应有七天下雨。见@sec-theory 与@thm-a，以及式@eq-a。
#lorem(30)

第二段落用于检查首行缩进。现代神经网络往往*过度自信*，其预测概率系统性地高于准确率。
= 理论 <sec-theory>
#definition(title: [校准映射])[一个单调不减函数 $g: [0,1] -> [0,1]$。]
#theorem[任何在 $P$ 上拟合的单调校准都无法消除偏移差 $Delta$。] <thm-a>
#proof[由三角不等式立即可得。]
$ "ECE" = sum_(m=1)^M (|B_m|)/n |"acc"(B_m) - "conf"(B_m)| $ <eq-a>
#figure(table(columns: 3, table.header[条件][原始][缩放后], [分布内], [9.8], [2.1], [新领域], [12.9], [6.4]), caption: [不同条件下的校准误差。]) <tab-a>
#callout(title: [主要发现])[分布偏移下的残余误差几乎完全由偏移差解释。]

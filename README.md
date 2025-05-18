# Monitoring Report Assistant

監視作業のアシスタントツールです。
```
git clone https://github.com/cdsl-research/monitoring-report-assistant.git
```

## get-grafana-panel-images.sh
監視作業で使用するGrafanaダッシュボードの画像を一括取得するツールです。


### 使い方

シェルスクリプトを実行します。
```
bash get-grafana-panel-images.sh
```

画像を現在のディレクトリに保存してよいか、確認します。（Y:はい / n:いいえ)
```
Are you sure you want to export to "/home/c0a22100/monitoring-report-assistant"? [Y/n]: Y
```

取得したいダッシュボードの日付を選択します。

今日の場合は「1」、特定の日付の場合は「YYYY-MM-DD」形式で入力してください。

```
Select a date. Enter 1 to select today's date, or specify a date (e.g., 2025-05-17): 1
```
取得したいダッシュボードで表示する時間帯を、日本時間で入力してください。（例: 09:00-12:00）
```
Enter the time range. (JST, start-end, e.g., 09:00-12:00): 09:00-12:00
```

### 実行結果の例
```
$ bash get-grafana-panel-images.sh 
Are you sure you want to export to "/home/c0a22100/monitoring-report-assistant"? [Y/n]: Y
Select a date. Enter 1 to select today's date, or specify a date (e.g., 2025-05-17): 1
Enter the time range. (JST, start-end, e.g., 09:00-12:00): 09:00-12:00
Image saved to /home/c0a22100/monitoring-report-assistant/grafana-20250518-113005-External-Clematis-Node-Check-1.png
Image saved to /home/c0a22100/monitoring-report-assistant/grafana-20250518-113007-External-Clematis-Node-Check-2.png
...
Image saved to /home/c0a22100/monitoring-report-assistant/grafana-20250518-113040-Internal-ESXi-3.png
Image saved to /home/c0a22100/monitoring-report-assistant/grafana-20250518-113042-Internal-ESXi-4.png
```

### 取得した画像の例

![grafana-20250518-113005-External-Clematis-Node-Check-1.png](example.png)

#### タイムゾーン
Grafana Image Rendererの仕様上、横軸がUTCで表示されます。

表示された時間に9時間を足して、日本時間に読み替えてください。

#### 出力される画像のサイズ変更

ソースコード内の`IMAGE_HEIGHT`と`IMAGE_WIDTH`の値を編集することで、出力される画像のサイズを変更できます。
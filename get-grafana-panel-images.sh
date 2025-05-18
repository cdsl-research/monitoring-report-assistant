#!/bin/bash

EXPORT_DIR="$(pwd)"
GRAFANA_URL="http://monitoring-master-ml:30080"
GRAFANA_AUTH="admin:admin"
IMAGE_HEIGHT=500
IMAGE_WIDTH=800 

# スクリーンショットを取得するパネル(PanelID)と、パネルが属するダッシュボード(DashboardID)を指定する
declare -A DASHBOARDS=(
  [aefowcgoe7apsd]="1,2,4,5,6,7,8"
  [aefp3nsnews1sb]="1"
  [aefp1an9r7zswa]="1,2,3,4"
  [befp3fsjb13pcd]="1"
  [bei9na4x5w64gd]="1,2,3,4"
)
# DashboardIDとダッシュボード名を指定する
declare -A NAMES=(
  [aefowcgoe7apsd]="External-Clematis-Node-Check"
  [aefp3nsnews1sb]="External-OpenVPN-Check"
  [aefp1an9r7zswa]="External-ESXi-Check"
  [befp3fsjb13pcd]="Internal-NAS-Check"
  [bei9na4x5w64gd]="Internal-ESXi-Check"
)
# 指定したダッシュボードのうち、スクリーンショットを取得する順番を指定する
dashboard_order=("aefowcgoe7apsd" "aefp3nsnews1sb" "aefp1an9r7zswa" "befp3fsjb13pcd" "bei9na4x5w64gd")


# エクスポート先の確認の表示を行う
read -p "Are you sure you want to export to \"${EXPORT_DIR}\"? [Y/n]: " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Export cancelled."
  exit 1
fi

# 日付を選択または入力させる
while true; do
  read -p "Select a date. Enter 1 to select today's date, or specify a date (e.g., 2025-05-17): " date_input
  if [[ "$date_input" == "1" ]]; then
    EXPORT_DATE=$(date +'%Y-%m-%d')
    break
  else
    if [[ "$date_input" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
      # 入力された日付が実際に存在するかどうかをdateコマンドで確認
      if date -d "$date_input" +%Y-%m-%d > /dev/null 2>&1; then
        EXPORT_DATE="$date_input"
        break
      else
        echo "Invalid date. Please enter a valid date."
      fi
    else
      echo "Invalid date format. Please use<\ctrl3348>-MM-DD or enter 1 for today."
    fi
  fi
done

# グラフの時間範囲を入力させる
while true; do
  read -p "Enter the time range. (JST, start-end, e.g., 09:00-12:00): " time_range_input
  if [[ -n "$time_range_input" && "$time_range_input" =~ ^[0-9]{2}:[0-9]{2}-[0-9]{2}:[0-9]{2}$ ]]; then
    time_range="${time_range_input}:00"
    break
  else
    echo "Invalid time range format. Please use HH:MM-HH:MM."
  fi
done

START_TIME_JST=$(echo "$time_range" | cut -d'-' -f1)
END_TIME_JST=$(echo "$time_range" | cut -d'-' -f2)
# JSTからUTCに変換する
START_TIME_UTC=$(date -d "${EXPORT_DATE} ${START_TIME_JST} JST" +%H:%M:%S)
END_TIME_UTC=$(date -d "${EXPORT_DATE} ${END_TIME_JST} JST" +%H:%M:%S)

# ダッシュボード内のパネルのスクリーンショットを取得する
for dashboard_id in "${dashboard_order[@]}"; do
  if [[ -v DASHBOARDS["$dashboard_id"] ]]; then
    panel_ids=$(echo "${DASHBOARDS[$dashboard_id]}" | tr ',' '\n')
    dashboard_name="${NAMES[$dashboard_id]}"
    for panel_id in $panel_ids; do
      output_file="grafana-$(date +'%Y%m%d-%H%M%S')-${dashboard_name}-${panel_id}.png"
      curl -s "${GRAFANA_URL}/render/d-solo/${dashboard_id}?orgId=1&panelId=${panel_id}&width=${IMAGE_WIDTH}&height=${IMAGE_HEIGHT}&from=${EXPORT_DATE}T${START_TIME_UTC}.000Z&to=${EXPORT_DATE}T${END_TIME_UTC}.000Z&timezone=UTC" -u "${GRAFANA_AUTH}" > "${output_file}"
      echo "Image saved to ${EXPORT_DIR}/${output_file}"
    done
  else
    echo "Dashboard ID ${dashboard_id} not found."
  fi
done
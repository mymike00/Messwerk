#include <QDebug>

#include "settings.h"
#include "wakelock.h"

WakeLock::WakeLock(void)
  : m_backgroundParts(0), m_screenLockParts(0)
{
}

WakeLock::~WakeLock(void)
{
}

void WakeLock::activateBackground(unsigned requestingPart)
{
    m_backgroundParts |= requestingPart;

    qDebug() << "Active background parts: " << m_backgroundParts;
}

void WakeLock::deactivateBackground(unsigned requestingPart)
{
    m_backgroundParts &= ~requestingPart;

    qDebug() << "Active background parts: " << m_backgroundParts;
}

void WakeLock::forceDeactivateBackground(void)
{
    // deactivate all parts
    deactivateBackground(0xFFFFFFFF);
}

void WakeLock::activateScreenLock(unsigned requestingPart)
{
    m_screenLockParts |= requestingPart;

    qDebug() << "Active screenLock parts: " << m_screenLockParts;
}

void WakeLock::deactivateScreenLock(unsigned requestingPart)
{
    m_screenLockParts &= ~requestingPart;

    qDebug() << "Active screenLock parts: " << m_screenLockParts;
}

void WakeLock::forceDeactivateScreenLock(void)
{
    // deactivate all parts
    deactivateScreenLock(0xFFFFFFFF);
}

void WakeLock::debugState(void)
{
    qDebug() << "libkeepalive is not available.";
}
